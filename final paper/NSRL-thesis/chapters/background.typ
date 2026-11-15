#pagebreak()
= Background <sec:background>
\
\
This chapter introduces the concepts the rest of the review depends on. The reader is assumed to be familiar with the standard reinforcement learning setting: Markov decision processes, value-based methods such as DQN @mnih2015, and policy-gradient and actor-critic methods such as PPO @sutton2018. @sec:bg-rl covers only the extensions of that setting that neurosymbolic methods build on. The larger part of the chapter, @sec:bg-symbolic, introduces the symbolic formalisms that appear in neurosymbolic RL systems, from logic and answer set programming to automata and programs. @sec:bg-grounding closes with the problem that connects the two halves: how symbols come to refer to anything an agent perceives. @fig:rl-loop gives an overview: it shows the points in the RL loop where the symbolic components introduced in this chapter can enter.

#figure(
  image("../graphics/rl-loop.svg", width: 100%),
  caption: [Where symbolic components can enter the RL loop. White boxes are learned neural components, shaded boxes are symbolic components. A system may use any subset: a symbolic state and reasoning layer (@sec:bg-symbolic), a reward machine (@sec:bg-automata), or a shield between the policy and the environment (@sec:bg-rl). The step from perception to symbols is the grounding problem (@sec:bg-grounding). The different layers dont necessarily interact in that order,same systems may have an agent in a feedback loop between a neural and Symbolic lays],
) <fig:rl-loop>

== Extensions of the RL setting <sec:bg-rl>

An RL problem is usually modelled as a Markov decision process (MDP) $cal(M) = chevron.l S, A, P, R, gamma chevron.r$, with states $S$, actions $A$, transition function $P(s' | s, a)$, reward function $R(s, a, s')$ and discount factor $gamma in [0, 1)$ @puterman1994. The defining assumption is the Markov property: the next state and reward depend only on the current state and action, not on the history that led there. Two consequences of this assumption matter for what follows.

First, many real tasks violate it.For example, if an agent must "fetch the key, then open the door", the correct action in a state depends on whether the key has already been collected, which the raw state may not record. 
Second, agents often cannot see the full state. A partially observable MDP (POMDP) adds a set of observations $Omega$ and an observation function $O(o | s', a)$, and the agent must act on a belief about the hidden state @kaelbling1998. Deep RL agents typically handle both problems implicitly, by stacking recent frames or adding recurrent memory. Several neurosymbolic methods instead handle them explicitly, by giving the agent a symbolic memory of what has happened (see @sec:bg-automata).

A second extension concerns time. Standard RL chooses a primitive action at every time step. The options framework allows an agent to choose temporally extended behaviours instead @sutton1999.
An option is a triple $omega = chevron.l I_omega, pi_omega, beta_omega chevron.r$, where $I_omega subset.eq S$ is the set of states in which the option can start, $pi_omega$ is the policy it follows while active, and $beta_omega : S -> [0, 1]$ gives the probability that it terminates in each state. A policy over options, called a *meta-policy*, chooses which option to run; the option then controls the agent until it terminates.

Options matter for neurosymbolic RL because they create a natural division of labour. Low-level options, such as "climb the ramp" or "go to the goal", involve continuous control from raw perception and suit neural policies. The meta-policy reasons about which skill to use in which situation, which suits symbolic representation. DUA @mitchener2022, SDRL @lyu2019 and PEORL @yang2018peorl all follow this pattern, shown in @fig:options: neural options at the bottom, a symbolic planner or rule set at the top.
#figure(
  image("../graphics/options.svg", width: 100%),
  
  caption: [A symbolic meta-policy over neural options. The meta-policy selects an option; the option issues primitive actions until its termination condition $beta$ fires, and control returns to the meta-policy.],
) <fig:options>

The reward signal raises its own problems. Sparse rewards make RL slow , because the agent receives no learning signal until it stumbles on a rewarding outcome. Reward shaping adds an extra reward $F$ to guide exploration. Ng et al. showed that shaping is safe,in tge sense of leaving the optimal policy unchanged, when it is potential-based: $F(s, a, s') = gamma Phi(s') - Phi(s)$ for some potential function $Phi$ over states @ng1999. Choosing a good $Phi$ requires knowing which states are closer to the goal, and symbolic task knowledge is ONE way to provide it.
We refer to a reward as *non-Markovian* when it depends on the history of states rather than only the current one, as in the key-and-door task above @bacchus1996. The standard remedy is to extend the state with a finite memory that tracks the relevant parts of the history, so that the extended process is Markovian again. Automata, introduced in @sec:bg-automata, are the usual form of that memory.

This leads to a side discussion regarding _Safety_, which  requires a further extension. In a constrained MDP, the agent maximises expected return subject to a bound on an expected cost: maximise $J_R(pi)$ subject to $J_C(pi) <= d$ @altman1999. Constraints of this kind hold only in expectation and are learned through trial and error, so they can be violated during training. _Shielding_ gives a stronger guarantee @alshiekh2018. A _shield_ is synthesised from a formal safety specification and an abstract model of the environment, and it sits between the agent and the environment. Before an action is executed, the shield either removes unsafe actions from the agent's choices or replaces an unsafe action with a safe one. Because the shield is a symbolic object, its guarantees can be verified, although they hold only as far as the abstract model is accurate. _Shielding_ is the basis of several neurosymbolic safety methods discussed later @yang2023 @khandelwal2026.

A last extension concerns how states are represented. Deep RL agents usually learn from pixels or flat feature vectors. Relational RL (RRL) #footnote[Interesting short lecture on this with regards to Deep Multi-agent RL:  https://www.youtube.com/watch?v=hfjT6cueTlg]  instead represents states as sets of objects and relations between them, such as `On(blockA, blockB)`, and learns policies or value functions over that representation @dzeroski2001. A relational policy that says "move any block that is on top of the target" applies to any number of blocks, which gives it a form of generalisation that a policy over fixed-length vectors lacks.


Modern work revives this idea as *object-centric* RL. OCAtari, for example, provides object lists with positions and attributes for Atari games, so that agents can learn from objects instead of pixels @delfosse2024oc. Object-centric states are the usual input to the logic policies discussed in later chapters, and producing them reliably from raw perception is a central difficulty (@sec:bg-grounding).

== Logic and answer set programming <sec:bg-symbolic>

Symbolic AI represents knowledge in a formal language and derives new knowledge by manipulating expressions according to rules @russell2021. This section and the three that follow introduce the formalisms that appear in neurosymbolic RL, roughly in order of increasing specialisation (as per the author). \@tab:formalisms in @sec:bg-example summarises where each enters the RL loop.

Propositional logic builds formulas from atomic propositions, such as `door_open` or `has_key`, using connectives for negation ($not$), conjunction ($and$), disjunction ($or$) and implication ($->$). An interpretation assigns a truth value to every proposition, and a set of formulas *entails* a formula $phi$ if $phi$ is true in every interpretation that makes the set true @russell2021. Propositional logic is simple and decidable, but it cannot express general statements about objects, so a separate proposition is needed for every object.

First-order logic adds variables, predicates and quantifiers. The rule

$ forall X . "enemy"(X) and "closeby"("agent", X) -> "jump" $

applies to every enemy, however many there are. This ability to state rules once and apply them to any number of objects is why first-order representations generalise better than propositional ones, and why most logic policies in RL are first-order @delfosse2023 @jiang2019. The cost is computational as entailment in full first-order logic is undecidable, so practical systems work with restricted fragments.

Logic programming restricts first-order logic to rules of the form

$ h <- b_1, dots, b_n $

read as "$h$ is true if $b_1$ to $b_n$ are all true". A *definite program* is a set of such rules, called Horn clauses, together with facts (rules with no body, i.e $n = 0$). Every definite program has a unique least model: the smallest set of ground atoms that satisfies all the rules, which can be computed by repeatedly applying the rules until nothing new is derived @lloyd1987. Prolog answers queries against such programs by backward chaining from the query to the facts.

Putting aside the computational costs, logic programs are attractive as policy representations because they are both executable and readable. A rule such as `jump(X) :- closeby(O1, O2), type(O1, agent), type(O2, enemy)` can be run to choose an action and also read by a person as an explanation of that choice @delfosse2023.

Definite programs cannot express default reasoning: conclusions that hold unless there is evidence to the contrary. Answer set programming (ASP) adds *default negation*, written `not`, and gives it a precise meaning through the stable model semantics of Gelfond and Lifschitz @gelfond1988 @lifschitz2019. A normal rule has the form

```
h :- b1, ..., bm, not c1, ..., not cn.
```

meaning "$h$ holds if every $b_i$ holds and no $c_j$ can be derived". The meaning of `not` is defined by a guess-and-check construction. Given a candidate set of atoms $X$, the *reduct* $P^X$ of program $P$ is obtained by deleting every rule containing `not c` for some $c in X$, and deleting the remaining negative literals from the other rules. The reduct is a definite program, so it has a least model. $X$ is an *answer set* (stable model) of $P$ if it equals the least model of $P^X$. Intuitively,(putting the jargon aside ) an answer set is simply a set of beliefs that justifies itself: every atom in it is derivable, and nothing is assumed that the program does not support.

A program can have zero, one or many answer sets, and this is what makes ASP useful for search and decision problems. A problem is encoded so that each answer set corresponds to a solution @brewka2011. Three further constructs are central:

- *Constraints*, rules with an empty head such as `:- unsafe(X), selected(X).`, eliminate every answer set in which the body holds.
- *Choice rules*, such as `{ initiate(O) : option(O) } = 1.`, generate alternatives: here, answer sets in which exactly one option is selected.
- *Weak constraints* rank the answer sets instead of eliminatig them. A weak constraint `:~ body. [w@l]` adds a penalty $w$ at priority level $l$ to every answer set in which the body holds. Optimal answer sets minimise penalties, comparing higher priority levels first @gebser2012.


These constructs give a direct way to represent a policy. In DUA, a choice rule generates one candidate answer set per option the agent could start, and a learned set of weak constraints ranks them, so the optimal answer set names the option to execute @mitchener2022. The weak constraint

```
:~ initiate(collect), not lava. [-1@8]
```
rewards (through a negative penalty) choosing the `collect` option at priority 8 whenever no lava is present.
\
ASP systems such as clingo solve programs in two steps: *grounding* replaces variables with all their possible values, and *solving* searches the resulting propositional program for answer sets @gebser2012. Grounding is often the bottleneck, since the ground program can grow very large with the number of objects. @fig:asp-pipeline shows the full pipeline for a DUA-style meta-policy

#figure(
  image("../graphics/asp-pipeline.svg", width: 100%),
  caption: [Answer set programming as a meta-policy. The program is grounded and solved; each answer set selects one option, and the weak constraints rank them. The answer set with the best penalty at the highest priority level determines the option to run. Penalties follow the weak constraints learned in DUA @mitchener2022.],
) <fig:asp-pipeline>

== Learning symbolic knowledge <sec:bg-learning>
The formalisms above require someone to write the rules. Inductive logic programming (ILP) learns them from examples @muggleton1991. Given background knowledge $B$, positive examples $E^+$ and negative examples $E^-$, an ILP system searches for a hypothesis $H$, a set of rules, such that

$ B union H ⊨ e "for every" e in E^+ quad "and" quad B union H ⊭ e "for every" e in E^- . $

The search is over a hypothesis space defined by a *language bias* that restricts which predicates and rule shapes are allowed. ILP systems can learn from very few examples and produce readable rules, but the hypothesis space grows rapidly with the number of predicates and the maximum rule length, which limits scalability @cropper2022.

ILASP extends ILP to answer set programs @law2020. Besides positive and negative examples, it can learn from *ordering examples*, which state that one answer set should be preferred to another in a given context, and it can learn weak constraints from them. This is exactly what DUA needs: it observes which options led to better outcomes in which symbolic states, turns those observations into ordering examples, and asks ILASP for weak constraints that explain them @mitchener2022. ILASP has also been used to learn the automata described in @sec:bg-automata from an agent's traces @furelosblanco2021.

Classical logic is discrete, so it cannot be trained by gradient descent and cannot express degrees of belief. Two lines of work relax this.

*Differentiable logic* assigns continuous weights to candidate rules and replaces logical inference with differentiable operations. In $partial$ILP, rules are generated from templates, each candidate clause receives a weight, and forward chaining is performed with soft truth values in $[0, 1]$, so that the weights can be learned by gradient descent from noisy examples @evans2018. Neural Logic Reinforcement Learning applied this to RL, representing the policy as weighted clauses whose head atoms are actions and training the weights with policy gradients @jiang2019. NUDGE follows the same principle with rule weights trained by an actor-critic method @delfosse2023. The cost is that the space of candidate rules must be fixed in advance, and its size limits what can be learned.

*Probabilistic logic programming* attaches probabilities to facts. In ProbLog, a fact `0.8::edge(a, b).` holds with probability 0.8, and the probability of a query is the total probability of the possible worlds in which it is derivable @deraedt2007. DeepProbLog lets neural networks supply these probabilities, for example a network that classifies an image as a digit, so that perception and logical reasoning are trained together @manhaeve2018. Probabilistic logic shields use the same machinery to compute the probability that an action is safe given uncertain perception, and to reweight the policy accordingly @yang2023.

A third way of acquiring symbolic knowledge is to translate it from natural language. Large language models can be prompted to produce answer set programs from a plain-English description of a problem, a task known as autoformalisation. Heyninck et al. use few-shot chain-of-thought prompting to generate ASP encodings of scheduling problems @Heyninck2024, while ASP-Bench evaluates an agentic approach in which the model writes, runs and revises its encoding using solver feedback @szeider2026aspbench. Unlike ILP, which needs examples,these methods need only a description of the task, but their output is not guaranteed to be correct: an encoding can be syntactically valid and still solve a different problem from the one described. For neurosymbolic RL this offers a cheap route to rules and task specifications, at the cost of having to check them, a trade-off examined experimentally in \@sec:experiments.

== Temporal logic and automata <sec:bg-automata>

Many tasks are naturally stated in terms of order: "get the coffee, then deliver it to the office, and never step on a decoration".Linear temporal logic(LTL) extends propositional logic with temporal operators over sequences of states @pnueli1977. With propositions $p$ and $q$, $bold(X) p$ means $p$ holds at the next step, $bold(F) p$ that $p$ eventually holds, $bold(G) p$ that $p$ always holds, and $p bold(U) q$ that $p$ holds until $q$ does. The coffee task becomes

$ bold(F)("coffee" and bold(F) "office") and bold(G) not "decoration" . $

Because in RL episodes are finite, the variant LTL#sub[f], interpreted over finite traces is often used. Every LTL#sub[f] formula can be translated into a deterministic finite automaton (DFA) that accepts exactly the traces satisfying it @degiacomo2013.

A *reward machine* is then an automaton used to specify a reward function @toroicarte2022. It has a finite set of states $U$ with an initial state $u_0$, and transitions labelled by sets of high-level propositions, such as `coffee` or `office`. A *labelling function* $L$ reports which propositions are true after each environment step. The machine moves between its states according to these labels and emits a reward on each transition. The reward machine for the coffee task has states for "no coffee yet", "has coffee" and "delivered", and gives reward only on the final transition.

These kind of reward machines solve the non-Markovian reward problem from @sec:bg-rl: the agent learns over the product of environment states and machine states, which is Markovian. They also expose the task's structure, which allows automated reward shaping, decomposition of the task into subtasks, and learning about several machine states from a single experience @toroicarte2022. LTL and other formal languages can be compiled into reward machines @camacho2019, and reward machines can themselves be learned from traces when they are not known in advance @furelosblanco2021.

== Graphs, programs and plans <sec:bg-other>


Three further representations appear in neurosymbolic RL, each trading expressiveness for ease of use in a different way. A knowledge graph represents knowledge as a set of triples $(h, r, t)$, each stating that relation $r$ holds between entities $h$ and $t$, for example `(gripper, cannot_lift, fragile_item)` @hogan2021. Knowledge graphs are less expressive than logic programs but easy to build, query and edit, and they can be combined with rules that derive new triples. In RL they have been used to represent world states, prune actions, and, in recent proposals, to hold an editable specification of rules, constraints and preferences that the agent consults while acting @khandelwal2026.

A policy can also be written as a program in a domain-specific language (DSL) with conditionals, loops and calls to perception and action primitives. Programmatic policies are readable, can be verified with program analysis tools, and often generalise to larger instances of a task. The difficulty is finding them, since the space of programs is discrete and vast. Three strategies recur. PIRL first trains a neural policy and then searches for a program that imitates it @verma2018. VIPER extracts a decision tree from a trained neural policy by imitation learning, and the tree can then be formally verified @bastani2018. LEAPS learns a continuous embedding of programs and searches that embedding for a program that maximises return @trivedi2021.

Classical planning represents a domain by actions with symbolic preconditions and effects. In the STRIPS formalism, each action has a precondition list, an add list and a delete list of atoms @fikes1971, and a planner searches for a sequence of actions that transforms the initial state into one satisfying the goal @ghallab2004. Planners produce long-horizon, goal-directed behaviour and can explain a plan step by step, but they need an accurate symbolic model of the domain. In hierarchical neurosymbolic RL, a planner chooses a sequence of high-level steps and learned options carry them out, with the outcome of execution fed back to revise the plan @yang2018peorl @lyu2019.

== How the four representation represent the same task <sec:bg-example>

The formalisms above can describe the same task in quite different ways, and the differences explain why neurosymbolic RL systems choose one over another.
Consider a simple gridworld task: the agent must pick up a key, then open a door, and must never step into lava. The raw state contains the agent's position and the positions of the objects; whether the key has been collected is not visible in the current frame once it has been picked up.
\
\
*As a temporal logic specification.* The task is a single LTL#sub[f] formula,

$ bold(F)("key" and bold(F) "door") and bold(G) not "lava", $

which states what must eventually happen and what must never happen, but says nothing about how to achieve it. Such a formula is useful as a specification to check behaviour against, or as input to a compiler that produces a reward machine @camacho2019.
\
\
*As a reward machine.* The same task becomes an automaton with three states: $u_0$ (no key yet), $u_1$ (has key) and a terminal accepting state. The transition from $u_0$ to $u_1$ fires when the label `key` is observed, and the transition from $u_1$ to the terminal state fires on `door` and gives reward 1. Observing `lava` in any state leads to a failing terminal state. The agent's memory problem disappears, because the machine state records whether the key has been collected, and the reward is no longer sparse in the sense that the agent can learn separately about reaching the key and reaching the door @toroicarte2022. @fig:reward-machine draws the machine.

#figure(
  image("../graphics/reward-machine.svg", width: 85%),
  caption: [Reward machine for the key, door and lava task. The machine moves on high-level labels reported by the labelling function, gives reward 1 when the door is reached after the key, and moves to a failing state if lava is observed. Its state $u_0$ or $u_1$ records whether the key has been collected.],
) <fig:reward-machine>
\
\

*As a first-order logic policy.* A policy over object-centric states might consist of weighted rules such as:
\
\
```python
0.9: go_to(K) :- type(K, key), not holding(agent, K).
0.9: go_to(D) :- type(D, door), holding(agent, K), type(K, key).
0.8: avoid(L) :- type(L, lava), closeby(agent, L).
```
\
Each rule maps a relational condition to an action, applies to any number of keys, doors or lava tiles, and can be read as an explanation of the agent's choice. Here the knowledge is in the policy itself rather than in the reward, and in differentiable logic methods the rule weights are learned from return @jiang2019 @delfosse2023.
\
\
*As an answer set program over options.* If the agent already has low-level skills `go_to(X)` and `open(X)`, an ASP meta-policy can choose among them:

```
{ initiate(O) : option(O) } = 1.
:- initiate(go_to(X)), lava_between(agent, X).
:~ initiate(go_to(K)), type(K, key), not has_key. [-1@2]
:~ initiate(open(D)), type(D, door), has_key. [-1@3]
```
\
The choice rule (line 1) creates one candidate answer set per option, the hard constraint (line 2) rules out any option whose path crosses lava, and the weak constraints (lines 2 & 3) prefer opening the door when the key is held and fetching the key otherwise. Unlike the logic policy, this representation separates hard safety requirements from soft preferences, and unlike the reward machine, it chooses actions directly. The `has_key` atom plays the same role as the reward machine's state, supplying the memory that the raw observation lacks. Rules of this kind are what ILASP learns from ordering examples in DUA @mitchener2022 @law2020.
\
\
All four representations rely on the same symbols: `key`, `door`, `lava`, `holding` and `closeby`. None of them says how those symbols are computed from the agent's observations. That question is the subject of @sec:bg-grounding.
\
\
#[
#set par(justify: false)
#figure(
  table(
    columns: (auto, 1fr, 1fr, auto),
    inset: (x: 6pt, y: 5pt),
    align: left + horizon,
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header[*Formalism*][*Representation*][*Where in RL loop*][*Example*],
    table.hline(stroke: 0.5pt),
    [First-order logic program], [Relational rules over objects], [Policy], [NUDGE @delfosse2023],
    [Answer set program], [Rules, constraints, preferences], [Meta-policy over options], [DUA @mitchener2022],
    [ILP / ILASP], [Learned rules], [Learning the symbolic component], [DUA, @furelosblanco2021],
    [Differentiable logic], [Weighted rules], [Policy trained by gradients], [NLRL @jiang2019],
    [Probabilistic logic], [Uncertain facts and rules], [Safety shield], [@yang2023],
    [LTL / automata], [Temporal task structure], [Reward function, memory], [Reward machines @toroicarte2022],
    [Knowledge graph], [Entities, relations, constraints], [Specification, action pruning], [@khandelwal2026],
    [Program (DSL)], [Control flow over primitives], [Policy], [PIRL @verma2018, LEAPS @trivedi2021],
    [Planning model], [Actions with preconditions, effects], [High-level planner], [SDRL @lyu2019],
    table.hline(stroke: 0.8pt),
  ),
  caption: [Symbolic formalisms used in neurosymbolic RL and where each enters the RL loop.],
) <tab:formalisms>
]

== The symbol grounding problem <sec:bg-grounding>
Every formalism in this chapter operates on symbols such as `enemy`, `closeby` or `coffee`. An RL agent, however, perceives pixels, sensor readings or text. Harnad called the question of how symbols acquire their meaning from perception the *symbol grounding problem* @harnad1990, and it is the point at which every neurosymbolic RL system must connect its two halves (depending on the role of the symbolic part).

Existing systems ground symbols in three broad ways, which differ in how much they rely on human design. 

The first is *hand-crafted extraction*: a fixed detector or set of heuristics maps perception to symbols. DUA's Detect module, for example, computes relations such as relative position from object bounding boxes using arithmetic rules written by its designers @mitchener2022. 

The second is *object-centric extraction*: an environment or a perception model supplies objects and their attributes, from which relational predicates are computed, as in OCAtari @delfosse2024oc and the concept bottlenecks of SCoBots @delfosse2024. 

The third is *learned grounding*: the mapping from perception to symbols is trained together with the symbolic component, so that errors in the reasoning can correct the perception, as in DeepProbLog @manhaeve2018 and end-to-end neurosymbolic policies @luo2024. @fig:grounding contrasts the three.

#figure(
  image("../graphics/grounding.svg", width: 100%),
  caption: [Three ways of grounding symbols. Hand-crafted extraction relies on designer-written rules; object-centric extraction computes relational concepts from object lists; learned grounding trains perception and reasoning together, so that errors in reasoning can update the perception module.],
) <fig:grounding>

\
The choice matters because a symbolic component is only as reliable as its symbols. A logic policy that reasons perfectly about `closeby(agent, enemy)` still fails if the detector misses the enemy, and a shield's safety guarantee holds only if its propositions are reported correctly. The grounding problem therefore referenced throughout the rest of this review, both in how methods are designed (\@sec:methods) and in what remains unsolved (\@sec:open).