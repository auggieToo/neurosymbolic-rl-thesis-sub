//reading log template author: Augustine mochoeneng , 21 March 2026
//log file for FINAL PAPER READING:COMP SCI - Explanation using defeasible rule sets 

#set page(margin: 2.2cm, numbering: "1")
#set text(size: 10.5pt)
#set par(justify: true)

#let e(date, key, body) = block(above: 1.2em, below: 0.4em, breakable: true)[
  #text(weight: "bold")[#date] #h(0.4em) #key \
  #body
]
#let abs(body) = block(inset: (left: 1.2em, right: 1.2em), above: 0.6em, below: 0.6em)[
  #text(size: 9.5pt)[#emph[Abstract:] #body]
]
#let phase(name) = block(above: 1.8em, below: 0.6em)[
  #text(size: 12pt, weight: "bold")[#name] #v(-0.6em) #line(length: 100%, stroke: 0.5pt)
]
#let goes(body) = text(size: 9.5pt)[→ #emph[#body]]
#let y = [☑]
#let n = [☐]

#align(center)[
  #text(size: 15pt, weight: "bold")[Reading log] \
  Neurosymbolic RL: how symbolic knowledge reshapes the learning agent
]

#phase[neurosymbolic AI]

#e("Aug 14", [_The Third AI Summer: AAAI Robert S. Engelmore Memorial Lecture_ @kautz2022])[
Starting point, and honestly a good one. Kautz goes through the AI summers and winters and then lists six ways to combine neural and symbolic systems, from "symbols in, symbols out, network in the middle" to fully neural systems with symbolic structure inside them. The notation took me a few reads, especially telling Neural\[Symbolic\] apart from Neural:Symbolic→Neural. My takeaway: "neurosymbolic" covers almost everything, so I need to narrow down a lot. I also tried to place a reward machine agent in his six types and couldn't do it cleanly, which is a hint that this taxonomy wasn't made with RL in mind.
#goes[taxonomies chapter, as the oldest and most general scheme; one line in the intro]
]

#e("Aug 14", [_Neurosymbolic AI: The 3rd Wave_ @garcez2023])[
The "three waves" paper: symbolic AI first, statistical AI second, and the third wave combines them. It is a position paper, so it argues rather than shows, and most of it is about knowledge representation inside networks. Nothing concrete for RL, but the waves framing works really well as the opening of my intro. One thing I noted: they care a lot about whether extracted knowledge is sound, and I haven't seen any RL paper check that yet.
#goes[intro, paired with Kautz]
]

#e("Aug 18", [_Neurosymbolic Artificial Intelligence (Why, What, and How)_ @sheth2023])[
This one I liked a lot. They use Kahneman's System 1 / System 2 for neural vs symbolic, and split methods into compression (push symbolic knowledge into the network) and lifting (pull symbols out of it).
- algorithm level: abstraction, analogy, long-term planning
- application level: explainability, interpretability, safety

The algorithm vs application split is basically how I want to structure "why symbols" in the intro. I'm not sure the H/M/L ratings in their table (p. ??) are measured, they look like the authors' judgement, so I'll cite them as such. I also had to look up what they actually mean by "analogy" and wrote myself a one-line definition for each of the three.
#goes[intro "why symbols"; compression vs lifting row in the taxonomy table]
]

#e("Aug 19", [_The Evolution of Artificial Intelligence: From Symbolic AI to Deep Learning_ @emma2025])[
History refresher from symbolic AI through expert systems and the winters to deep learning. Nothing new for me really, but it's a clean single source for the timeline so I don't have to cite ten things. Used it to sanity check my intro story: symbols, then neurons, then the limits of neurons. Need to make sure my dates line up with the original papers.
#goes[intro timeline]
]

#e("Aug 25", [_Learning Representations by Back-Propagating Errors_ @rumelhart1986 \
_Deep Learning_ @lecun2015 \
_Human-Level Control through Deep Reinforcement Learning_ @mnih2015 \
_Mastering the Game of Go with Deep Neural Networks and Tree Search_ @silver2016])[
The classics for the intro: backprop, the Nature deep learning review, DQN on Atari, and AlphaGo. I didn't reread these fully, just checked I'm citing each one for the right thing. DQN is the "deep RL works" moment and the obvious starting point for the RL half of the story. AlphaGo is search plus networks, which some people call neurosymbolic, so I need to say explicitly that I'm scoping that kind of system out.
#goes[intro; scope paragraph]
]

#e("Aug 30", [_Stop Explaining Black Box Machine Learning Models for High Stakes Decisions and Use Interpretable Models Instead_ @rudin2019])[
#abs[Black box machine learning models are currently being used for high stakes decision-making throughout society, causing problems throughout healthcare, criminal justice, and in other domains. People have hoped that creating methods for explaining these black box models will alleviate some of these problems, but trying to \textit{explain} black box models, rather than creating models that are \textit{interpretable} in the first place, is likely to perpetuate bad practices and can potentially cause catastrophic harm to society. There is a way forward -- it is to design models that are inherently interpretable. This manuscript clarifies the chasm between explaining black boxes and using inherently interpretable models, outlines several key reasons why explainable black boxes should be avoided in high-stakes decisions, identifies challenges to interpretable machine learning, and provides several example applications where interpretable models could potentially replace black box models in criminal justice, healthcare, and computer vision. ]
Big one for me. Her argument is that explaining a black box afterwards is the wrong approach for high-stakes decisions, because the explanation isn't the model and can be wrong about it. She also argues the accuracy cost of interpretable models is smaller than people think. My takeaway for NSRL: when an agent has readable rules *and* a neural part (NUDGE's critic, BlendRL's neural policy), is the readable part actually what acts? Nobody seems to check this. #n turn this into an experiment
#goes[critical comparison, interpretability; reason I excluded post-hoc explanation methods]
]

#e("Aug 30", [_Artificial Intelligence: A Modern Approach_ @russell2021])[
Went back to the AIMA chapters on logic, knowledge representation and planning. The point was to make sure my background definitions are the standard ones and not something I half-remember. Useful for the definition of a knowledge base and entailment. Not something I'll cite much, but good to have one textbook anchor.
#goes[background, symbolic AI]
]

#phase[Late August and September: narrowing to RL]

#e("Aug 30", [_A Survey on Neural-Symbolic Learning Systems_ @yu2023])[
Three classes: learning for reasoning, reasoning for learning, learning-reasoning. It's clean and easy to explain, so I built the first version of the presentation around it and cloned their figures 7 to 9 in draw.io (took way too long). The problem I keep hitting is hierarchical systems: DUA learns its symbolic level from data and then that symbolic level controls neural skills, so it's both directions at once. Not sure where they put early systems like DSRL. #n recheck Section 2
#goes[taxonomies chapter; "Yu class" column in the method families table]
]

#e("Sep 5", [_Neurosymbolic Reinforcement Learning and Planning: A Survey_ @acharya2023])[
The survey closest to my topic, and my main backbone for a while. It applies the same three-way split to RL and planning, goes through which part of the agent each system changes, and puts DSRL under learning for reasoning. Their open-problems section lists verification and validation as a major gap (p. ??). Since it's from 2023, a lot has happened after it, BlendRL, NSAM, LLM-written rules, which gives me the idea for the trends chapter: "what changed since this survey".
#goes[taxonomies; trends chapter framing; verification gap in open problems]
]

#e("Sep 6", [_Neuro-Symbolic AI in 2024: A Systematic Review_ @colelough2024])[
Systematic review of 167 papers. Learning and inference 63%, knowledge representation 44%, logic and reasoning 35%, explainability and trustworthiness 28%, meta-cognition 5%. Papers can be in several categories so it doesn't add up to 100, which I need to say so nobody thinks I added wrong. Main takeaway: explainability is claimed everywhere but studied much less, which supports where my critique is going.
#goes[taxonomies (areas view); open problems, evaluation]
]

#e("Sep 6", [_Reinforcement Learning: An Introduction_ @sutton2018 \
_Markov Decision Processes: Discrete Stochastic Dynamic Programming_ @puterman1994])[
RL background: MDPs, value functions, Q-learning, policy gradients. The prof said not to go deep on basic RL, so I only need enough to define terms and move on. Sutton and Barto for the RL side, Puterman for the formal MDP definition. I'll keep this to a couple of paragraphs and spend the space on what goes beyond PPO and DQN.
#goes[background, start of the RL section]
]

#e("Sep 18", [_Planning and Acting in Partially Observable Stochastic Domains_ @kaelbling1998 \
_Between MDPs and Semi-MDPs: A Framework for Temporal Abstraction in Reinforcement Learning_ @sutton1999])[
POMDPs and options. Options are how pretty much every hierarchical NSRL paper defines its skills, so I can't skip this. POMDPs matter because the moment the reward depends on history (like in reward machines) the plain MDP assumption breaks. These two are the "beyond basic RL" part the prof asked for.
#goes[background, extensions of the RL setting; options figure]
]

#e("Sep 18", [_Towards Deep Symbolic Reinforcement Learning_ @garnelo2016])[
Where NSRL as a term starts. A network maps raw images to a symbolic description of objects, and a symbolic learner acts on that. Only tested on a toy game, but the argument (symbols are more data-efficient, transfer better and can be read) is the one every later paper repeats. Question I keep coming back to: why did it take until about 2023 for this to work on Atari? I think the answer is that OCAtari handed everyone the objects for free, not that the methods got smarter.
#goes[intro history; state representations family]
]

#e("Sep 21", [_Relational Reinforcement Learning_ @dzeroski2001])[
Relational RL, way before deep learning. States are logical facts like `on(block1, block2)` and the learned value function generalises across problems with different numbers of objects. Good for showing the idea of RL over symbols is old. Also a nice contrast: here the symbols were the whole point, while in DSRL they have to be produced by a network.
#goes[state representations family]
]

#e("Sep 22", [_Detect, Understand, Act: A Neuro-Symbolic Hierarchical Reinforcement Learning Framework_ @mitchener2022])[
#abs[In this paper we introduce Detect, Understand, Act (DUA), a neuro-symbolic reinforcement learning framework. The Detect component is composed of a traditional computer vision object detector and tracker. The Act component houses a set of options, high-level actions enacted by pre-trained deep reinforcement learning (DRL) policies. The Understand component provides a novel answer set programming (ASP) paradigm for symbolically implementing a meta-policy over options and effectively learning it using inductive logic programming (ILP). We evaluate our framework on the Animal-AI (AAI) competition testbed, a set of physical cognitive reasoning problems. Given a set of pre-trained DRL policies, DUA requires only a few examples to learn a meta-policy that allows it to improve the state-of-the-art on multiple of the most challenging categories from the testbed. DUA constitutes the first holistic hybrid integration of computer vision, ILP and DRL applied to an AAI-like environment and sets the foundations for further use of ILP in complex DRL challenges.]
Favourite paper so far, partly because it's ASP + ILASP, which is what I work on anyway.
- detector turns frames into facts, an ASP program picks one of nine pretrained skills
- weak constraints learned with ILASP from very few arenas
- state of the art in its trained categories, 3rd overall in Animal-AI if it had entered
- fails every task with transparent objects, because the detector works on colour

That last point is going to be my main grounding example. Big open question for me: how much of the success is the hand-made detector and nine hand-trained skills, and how much is the ASP part? Spent a lot of time on this one for the slides, including the walkthrough of how the program picks a skill.
#goes[high-level control family; grounding example in background and open problems]
]

#e("Sep ??", [_The Animal-AI Olympics_ @crosby2019])[
Animal-AI. The arenas are based on experiments from animal cognition (food retrieval, obstacles, object permanence and so on) and it was run as a competition. I mainly read it to explain what DUA's "3rd overall" actually means. It's one of the few benchmarks in the field where the authors didn't design the test environments themselves, which makes DUA's result more convincing than most.
#goes[domains, cognitive testbeds]
]

#e("Sep 24", [_The Stable Model Semantics for Logic Programming_ @gelfond1988 \
_Answer Set Programming_ @lifschitz2019 \
_Answer Set Programming at a Glance_ @brewka2011 \
_Answer Set Solving in Practice_ @gebser2012])[
ASP background: stable models, the reduct, choice rules, weak constraints `[w@l]`. I know most of this from my research work, but I reread the definitions so the background section is precise. Brewka et al. is the short readable overview, Gebser et al. is the practical one. Gebser is also where I'll cite the grounding blow-up when there are many objects.
#goes[background, logic and ASP; ASP pipeline figure; scalability in open problems]
]

#e("Sep 24", [_Foundations of Logic Programming_ @lloyd1987])[
Logic programming foundations. Only needed for definitions: Horn clauses, SLD resolution, least models. It's dense and old but it's the standard citation. I'll keep the logic programming part of the background short and move quickly to ASP.
#goes[background]
]

#e("Sep 24", [_Inductive Logic Programming_ @muggleton1991 \
_Inductive Logic Programming at 30: A New Introduction_ @cropper2022 \
_The ILASP System for Inductive Learning of Answer Set Programs_ @law2020])[
ILP. Muggleton is the original, Cropper and Dumančić is the readable modern intro, and ILASP is what DUA uses. ILASP can learn weak constraints from ordered examples, which is exactly how DUA learns which skill to prefer. The problem everyone runs into is that the search grows fast with the number of predicates and rule length, which is why every ILASP example in RL has a tiny vocabulary.
#goes[background, learning symbolic knowledge; open problems]
]

#e("Sep 24", [_Learning Explanatory Rules from Noisy Data_ @evans2018 \
_Neural Logic Reinforcement Learning_ @jiang2019])[
∂ILP and NLRL. Differentiable ILP turns rule learning into gradient descent by giving every candidate rule a weight, but the candidate rules come from templates fixed in advance. NLRL uses this as an RL policy, which makes it the first logic policy trained with policy gradients. The templates are the catch: they keep the search manageable but limit what the agent can express.
#goes[logic policies family]
]

#e("Sep 24", [_ProbLog: A Probabilistic Prolog and Its Application in Link Discovery_ @deraedt2007 \
_DeepProbLog: Neural Probabilistic Logic Programming_ @manhaeve2018])[
ProbLog and DeepProbLog. ProbLog attaches probabilities to facts and rules, DeepProbLog lets neural networks produce those probabilities. I need these mostly to explain probabilistic logic shields properly later. Also a good example of end-to-end training through logic, which ties into the trends chapter.
#goes[background; action constraints family]
]

#e("Sep 27", [_The Symbol Grounding Problem_ @harnad1990])[
The symbol grounding problem: how do symbols get their meaning if they're only defined by other symbols? Short and old, but it describes the main weakness of the whole field. Every NSRL system either gets its symbols handed to it or has a detector that can fail. It gets its own section at the end of the background, and it comes back in the open problems.
#goes[background, symbol grounding; grounding figure]
]

#e("Sep 27", [_Reward Machines: Exploiting Reward Function Structure in Reinforcement Learning_ @toroicarte2022])[
#abs[Reinforcement learning (RL) methods usually treat reward functions as black boxes. As such, these methods must extensively interact with the environment in order to discover rewards and optimal policies. In most RL applications, however, users have to program the reward function and, hence, there is the opportunity to make the reward function visible -- to show the reward function's code to the RL agent so it can exploit the function's internal structure to learn optimal policies in a more sample efficient manner. In this paper, we show how to accomplish this idea in two steps. First, we propose reward machines, a type of finite state machine that supports the specification of reward functions while exposing reward function structure. We then describe different methodologies to exploit this structure to support learning, including automated reward shaping, task decomposition, and counterfactual reasoning with off-policy learning. Experiments on tabular and continuous domains, across different tasks and RL agents, show the benefits of exploiting reward structure with respect to sample efficiency and the quality of resultant policies. Finally, by virtue of being a form of finite state machine, reward machines have the expressive power of a regular language and as such support loops, sequences and conditionals, as well as the expression of temporally extended properties typical of linear temporal logic and non-Markovian reward specification. ]
Reward machines. The reward is a finite-state machine over high-level events, and because the agent can see the structure it can exploit it three ways: shaping, decomposition (HRM) and counterfactual updates (CRM). Tested on OfficeWorld, CraftWorld and WaterWorld. CRM confused me at first, why is it allowed to update states the agent wasn't in? Got it eventually: the environment's transition doesn't depend on the machine state, so the same experience is valid for every machine state.

Two questions that I think are worth an experiment: is the speed-up from the automaton itself or just from knowing the task, and what happens if the machine is wrong? #n experiment idea
#goes[reward structure family; running example in background; Experiments 1 and 2]
]

#e("Sep 27", [_Rewarding Behaviors_ @bacchus1996 \
_The Temporal Logic of Programs_ @pnueli1977 \
_Linear Temporal Logic and Linear Dynamic Logic on Finite Traces_ @degiacomo2013 \
_LTL and Beyond: Formal Languages for Reward Function Specification in Reinforcement Learning_ @camacho2019])[
Non-Markovian rewards, LTL, LTL on finite traces, and compiling LTL into reward machines. Bacchus et al. is the earliest paper I found on rewards that depend on history. LTLf is the one that actually matters for episodic RL tasks, since episodes end. Camacho et al. connects it all: write the task in a formal language and get a reward machine automatically.
#goes[background, temporal logic and automata; key/door/lava example]
]

#e("Sep 30", [_Induction and Exploitation of Subgoal Automata for Reinforcement Learning_ @furelosblanco2021])[
Learns the subgoal automaton with ILASP while the agent is doing RL, and refines it when a trace doesn't fit. ASP again, which I like. It answers the obvious objection to reward machines ("who writes the machine?") at least for small tasks. The interleaving of learning the automaton and learning the policy is clever, but I want to know how it does when traces are noisy.
#goes[reward structure family]
]

#e("Sep 30", [_Interpretable and Explainable Logical Policies via Neurally Guided Symbolic Abstraction_ @delfosse2023])[
#abs[The limited priors required by neural networks make them the dominating choice to encode and learn policies using reinforcement learning (RL). However, they are also black-boxes, making it hard to understand the agent's behaviour, especially when working on the image level. Therefore, neuro-symbolic RL aims at creating policies that are interpretable in the first place. Unfortunately, interpretability is not explainability. To achieve both, we introduce Neurally gUided Differentiable loGic policiEs (NUDGE). NUDGE exploits trained neural network-based agents to guide the search of candidate-weighted logic rules, then uses differentiable logic to train the logic agents. Our experimental evaluation demonstrates that NUDGE agents can induce interpretable and explainable policies while outperforming purely neural ones and showing good flexibility to environments of different initial states and problem sizes]
NUDGE. The policy is a set of weighted first-order rules, and a pretrained neural agent guides which rules are kept. Rule I want to quote: `0.574: jump(X) :- closeby(O1,O2), type(O1,agent), type(O2,enemy)`. On GetOut+ it gets 3.60 vs PPO's $-20.88$ (table p. ??).

But GetOut+ just adds enemies, and the rule is about "closeby enemy", so of course it still applies. Is that generalisation, or invariance by design? Also, if I delete the top-weighted rules, does the behaviour actually change? That would be a direct test of Rudin's point. #n try to reproduce it
#goes[logic policies family; intro example; generalisation caveat in critical comparison; Experiment 3]
]

#e("Sep 30", [_SDRL: Interpretable and Data-Efficient Deep Reinforcement Learning Leveraging Symbolic Planning_ @lyu2019 \
_PEORL: Integrating Symbolic Planning and Hierarchical Reinforcement Learning for Robust Decision-Making_ @yang2018peorl])[
SDRL and PEORL: a symbolic planner on top of RL skills. PEORL's planner proposes a plan, RL learns to execute it, and the results go back to improve the plan. SDRL adds a meta-controller and works on Montezuma's Revenge, which is exactly the kind of long, sparse-reward task where this should help. My worry: who writes the planning domain? It feels like most of the knowledge lives there.
#goes[high-level control family; Montezuma in domains]
]

#e("Oct 1", [_STRIPS: A New Approach to the Application of Theorem Proving to Problem Solving_ @fikes1971 \
_Automated Planning: Theory and Practice_ @ghallab2004])[
STRIPS and the automated planning textbook. STRIPS for the classic action model (preconditions, add and delete lists), Ghallab et al. for planning more generally. Needed so the high-level control section makes sense to someone who hasn't done planning. Short background paragraph only.
#goes[background, graphs, programs and plans]
]

#phase[October: methods, safety, getting critical]

#e("Oct 1", [_BlendRL: A Framework for Merging Symbolic and Neural Policy Learning_ @shindo2025])[
BlendRL. A neural policy over pixels and a logic policy over objects, mixed by a learned weight: $pi = beta dot pi_"neural" + (1 - beta) dot pi_"logic"$. The rules are generated by GPT-4o instead of written by hand, which I didn't expect. On modified Kangaroo, Seaquest and DonkeyKong, PPO gets 0 and BlendRL gets 187, 113 and 263. Same question as NUDGE though, who chose the modifications? And if $beta$ leans neural in the hard moments, which part is really the policy?
#goes[blended policies row; generalisation discussion; LLM trend]
]

#e("Oct 1", [_OCAtari: Object-Centric Atari 2600 Reinforcement Learning Environments_ @delfosse2024oc \
_Interpretable Concept Bottlenecks to Align Reinforcement Learning Agents_ @delfosse2024])[
OCAtari and SCoBots. The big realisation: OCAtari gets the objects from the emulator's RAM, not from images. That explains why the generalisation results in NUDGE and BlendRL look so clean, perception just isn't being tested. SCoBots adds a concept bottleneck between objects and policy, and I like that you can remove a concept and see what breaks, that's an actual interpretability test.
#goes[state representations; critical comparison, generalisation; open problems, grounding]
]

#e("Oct 1", [_End-to-End Neuro-Symbolic Reinforcement Learning with Textual Explanations_ @luo2024])[
INSIGHT. Learns the perception and the symbolic policy together, end to end, and uses an LLM to turn the policy into text explanations. End-to-end is the trend I want to point to, since it removes the "symbols given for free" problem at least partly. But is a text explanation of a policy still interpretability in Rudin's sense, or is it a post-hoc explanation again?
#goes[logic policies; trends, end-to-end training]
]

#e("Oct 1", [_Programmatically Interpretable Reinforcement Learning_ @verma2018 \
_Verifiable Reinforcement Learning via Policy Extraction_ @bastani2018 \
_Learning to Synthesize Programs as Interpretable and Generalizable Policies_ @trivedi2021])[
Programmatic policies. PIRL searches for a program guided by a neural policy (on TORCS), VIPER extracts a decision tree you can formally verify, LEAPS searches a learned embedding of programs (on Karel). The VIPER point is the one I'll use most: the guarantee is for the tree, not for the neural policy it copied. Program search is clearly the hard part in all three.
#goes[programmatic policies family; verification in open problems]
]

#e("Oct 3", [_Code as Policies: Language Model Programs for Embodied Control_ @liang2023])[
Code as Policies. An LLM writes the robot control code directly from a description. There's no RL training at all, which made me unsure whether to include it. I kept it because it's the clearest example of "LLM writes the policy", and that's the direction BlendRL and others are moving in.
#goes[programmatic policies; domains, robotics; LLM trend]
]

#e("Oct 20", [_Encoding Human Domain Knowledge to Warm Start Reinforcement Learning_ @silva2021])[
PROLONETS. Human rules become the initial structure and weights of the network, and RL refines from there. Tested on Gym tasks and modified StarCraft II, and even rules from untrained people helped. The catch is that after training it's just a network, so the interpretability is gone. Good example for my "knowledge as a prior" family.
#goes[knowledge priors family; StarCraft II in domains]
]

#e("Oct 20", [_Constrained Markov Decision Processes_ @altman1999 \
_Safe Reinforcement Learning via Shielding_ @alshiekh2018 \
_Safe Reinforcement Learning via Probabilistic Logic Shields_ @yang2023])[
Safety, three ways. Constrained MDPs are the non-symbolic alternative (constraints in expectation). Shields block unsafe actions using a formal spec and an abstract model. Probabilistic shields use ProbLog so they work with noisy perception and stay differentiable. My takeaway: the guarantee only covers the symbolic model, not the perception that decides whether the constraint applies. Also, NS papers mostly compare against unconstrained agents, not constrained RL, which isn't really fair.
#goes[action constraints family; safety section of the critical comparison]
]

#e("Oct 21", [_Neuro-Symbolic Artificial Intelligence: A Task-Directed Survey in the Black-Box Models Era_ @delvecchio2025])[
Task-directed survey: rule mining, rule enforcement, program synthesis. Organising by task instead of architecture just clicked for me. This is what made me restructure chapter 4 by RL component (what does the symbolic part change: state, policy, reward, constraints...) instead of by Yu's three classes. Probably the most important structural decision in the paper.
#goes[taxonomies; the whole structure of the method families chapter]
]

#e("Oct 27", [_Neurosymbolic Association Rule Mining from Tabular Data_ @karabulut2025 \
_SymbolicAI: A Framework for Logic-Based Approaches Combining Generative Models and Solvers_ @dinu2024])[
Neither is RL. Karabulut et al. mine association rules from tables with a neurosymbolic approach, a nice example of the rule-mining side of Delvecchio's tasks. SymbolicAI glues LLMs to solvers and logic engines. That second one made me think: could an LLM just write the reward machine from a plain-English task? It would be cheap to test.
#goes[intro; idea for Experiment 2]
]

#e("Oct 27", [_Knowledge Graphs_ @hogan2021])[
Knowledge graphs survey. Needed for the "graphs, programs and plans" background section, and because Khandelwal et al. want to store an agent's rules in one. Mostly read the intro and the parts on schemas and reasoning. It's huge, I didn't read all of it.
#goes[background, graphs]
]

#e("Oct 27", [_Towards a Rigorous Science of Interpretable Machine Learning_ @doshivelez2017])[
Interpretability should be evaluated properly: with real users on real tasks, with people on simplified tasks, or at least with proxies, and most work only does the last one. Together with Rudin, this is the backbone of my interpretability critique. I went looking for a single NSRL paper with a user study and didn't find one.
#goes[critical comparison, interpretability; open problems, evaluation]
]

#e("Oct 29", [_Policy Invariance under Reward Transformations: Theory and Application to Reward Shaping_ @ng1999])[
Potential-based shaping, $F = gamma Phi(s') - Phi(s)$, is the only kind of shaping that guarantees the optimal policy doesn't change. I need it for the control condition in Experiment 1: same task knowledge as the reward machine, but given as a numeric potential instead of an automaton. My goal state's potential isn't zero, so strictly it's not invariant, which goes in threats to validity.
#goes[background; Experiment 1 design; threats to validity]
]

Turning point around here. Almost every comparison gives the NS agent extra knowledge (a machine, rules, a spec) that the deep RL baseline doesn't get. So "NSRL beats deep RL" might just mean "informed beats uninformed". This becomes the first section of the critical comparison, and Experiment 1 tests it directly.

#phase[Late October to November: recent stuff]

#e("Oct 31", [_RLSF: Reinforcement Learning via Symbolic Feedback_ @jha2024])[
RLSF. RL fine-tunes an LLM and the reward comes from compilers and solvers, which give detailed certificates pointing at errors instead of one score. +52.64% compilation accuracy over SFT for CodeGemma-2b. I wasn't sure it counts as NSRL since the symbolic part is "just" a verifier, but I decided it fits the reward-structure family. Made me add a language models row to the domains chapter.
#goes[reward structure family; domains, language models]
]

#e("Oct 31", [_Neuro-Symbolic Artificial Intelligence: Towards Improving the Reasoning Abilities of Large Language Models_ @yang2025llm])[
Survey on neurosymbolic methods for improving LLM reasoning. Background for the LLM trend, mostly to show that the LLM + symbolic tools direction is big outside RL too. Skimmed the RL-relevant parts. Gave me vocabulary for talking about LLMs as a source of symbolic knowledge.
#goes[trends, LLMs]
]

#e("Oct 31", [_Toward Neurosymbolic Reinforcement Learning via Editable Specifications_ @khandelwal2026])[
#abs[Reinforcement learning systems are commonly adapted to new settings by retraining or fine-tuning policies. This default is costly, difficult to audit, and poorly aligned with structured requirement changes such as revised safety rules, new operational constraints, or updated user preferences. We argue for an alternative abstraction: adaptation via edits to an external, human-readable specification that the agent consults at execution time. We propose conditioning decision-making on an editable knowledge graph encoding (i) applicability rules capturing action preconditions and high-level effects, (ii) hard constraints defining feasibility, and (iii) soft preferences shaping tradeoffs among feasible behaviors. Requirement changes become graph edits, not policy rewrites, operationalized through constraint-based action shielding and preference-driven objective shaping. This enables immediate, auditable behavior updates with zero or minimal gradient-based adaptation. We outline edit-based evaluation protocol and highlight open problems in specification design, edit inference, and guarantees. ]
Rules, hard constraints and soft preferences live in an external, editable knowledge graph, and the agent consults it at execution time, with shielding for enforcement. So a change in requirements becomes an edit to the graph instead of a retraining run. It's a position paper with no experiments, which I need to say clearly. Open questions: who keeps the graph consistent, and how are soft preferences enforced if shielding is about hard constraints?
#goes[intro; action constraints family; networks domain]
]

#e("Oct 31", [_Neuro-Symbolic Action Masking for Deep Reinforcement Learning_ @han2026])[
NSAM. Learns a mapping from states to symbolic models of the domain constraints and uses them to mask infeasible actions. Near-zero violations on Sudoku, N-Queens, graph colouring and Visual Sudoku. Strongest safety result I have, but the constraints are the puzzle's own rules, so they're correct by construction. The PSDD part went over my head.
#goes[action constraints family; constrained problems domain; critical comparison, safety]
]

#e("Octoer 31", [_Sample-Efficient Neurosymbolic Deep Reinforcement Learning_ @veronese2026])[
SR-DQN. ASP rules learned on small instances of a task guide a DQN on bigger ones, by biasing exploration and rescaling Q-values, and the rules' influence decays over training. Better sample efficiency than reward machine baselines and robust to imperfect rules. One of the only papers that takes wrong knowledge seriously, which pushed me to test corrupted machines in Experiment 1.
#goes[knowledge priors family; "brittleness to wrong knowledge" in the critical comparison]
]

#e("Nov 13", [_Demystifying Deep Reinforcement Learning: A Neuro-Symbolic Framework for Interpretable Open RAN Automation_ @lu2026])[
DeRAN. Distils deep RL policies for 5G network control into closed-form expressions and first-order rules that operators can audit. Keeps 78% to 87% of the original performance. That's the honest number for what interpretability costs, and one of the few papers where the motivation is a real deployment requirement and not a benchmark. Still no user study though.
#goes[programmatic policies; networks domain; performance ceilings in the critical comparison]
]

#e("Nov 13", [_Reward Machines for Vision-Based Robotic Manipulation_ @camacho2021 \
_Neuro-Symbolic Reinforcement Learning with First-Order Logic_ @kimura2021 \
_Towards Safe Autonomous Driving Policies using a Neuro-Symbolic Deep Reinforcement Learning Approach_ @sharifi2023])[
Found these while filling gaps in the domains chapter (robotics, text games, driving). Camacho et al. is the useful one: in robot manipulation, the machine state alone helped on the short task but not the long one, and shaping was needed. That's exactly what my plain RM agent did in Experiment 1, which was nice to see. Kimura and Sharifi are mainly there so the domains table isn't all games and gridworlds.
#goes[domains; Experiment 1 discussion]
]

#phase[Still don't get]

- where hierarchical systems actually go in Yu's classes
- how NUDGE's neural guide scores the candidate rules
- the PSDD part of NSAM
- how much of each system's success is just the hand-made parts (detectors, skills, DSLs)

#phase[Checklist]



#bibliography("references.bib", style: "ieee")
