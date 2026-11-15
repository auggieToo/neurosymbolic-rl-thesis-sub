#pagebreak()

= Experiments <sec:experiments>
\
\
@sec:evidence pointed out three weak spots in the evidence for neurosymbolic RL. Most comparisons give the neurosymbolic agent more knowledge than its baseline. Few report what happens when the symbolic knowledge is wrong. Interpretability claims are rarely tested for faithfulness. It also noted a recent trend toward generating symbolic knowledge with language models (@sec:trends). There's three small experiments in this chapter that address these points directly. They're not meant to establish new results at scale. They're meant to test, under controlled conditions, claims that the reviewed papers make or assume.

Experiment 1 asks whether a reward machine helps because of its symbolic structure or only because of the task knowledge it contains, and what happens when the machine is wrong. Experiment 2 asks whether a language model can write a correct reward machine from a plain-English task description. Experiment 3 asks whether NUDGE can be reproduced from its public code, and whether its readable rules are faithful to the agent's behaviour.

All three were designed to run on Google Colab hardware. Experiments 1 and 2 are tabular and run on a CPU. Experiment 3 uses a GPU runtime.

== Environment and agents

Experiments 1 and 2 use a re-implementation of the OfficeWorld domain of Toro Icarte et al. @toroicarte2022 with a map of our own design (@fig:office-map). The grid has $12 times 9$ cells divided into twelve $3 times 3$ rooms connected by doors. When the agent enters a marked cell it observes one high-level event. _a_ to _d_ for the four corner rooms, _e_ for a coffee machine, _f_ for the mail room, _g_ for the office and _n_ for a decoration. The labelling function is exact, so these experiments isolate task structure and say nothing about grounding (@sec:bg-grounding).

#figure(
  image("../graphics/office-map.svg", width: 55%),
  caption: [The environment used in Experiments 1 and 2. Letters mark the cells where events are observed; grey cells are decorations. Thick lines are walls, with a door in the middle of each shared wall.],
) <fig:office-map>

@tab:tasks lists the six tasks. The first four are modelled on tasks from the original OfficeWorld. The last two are new tasks written for this review, with longer ordered sequences. Every task except _patrol_ fails if the agent steps on a decoration.

#[
#set par(justify: false)
#figure(
  table(
    columns: (auto, 1fr, auto),
    inset: (x: 6pt, y: 5pt),
    align: (left + horizon, left + horizon, center + horizon),
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header[*Task*][*Description given to the language model*][*States*],
    table.hline(stroke: 0.5pt),
    [coffee], [Get a coffee and deliver it to the office.], [2],
    [mail], [Pick up the mail and deliver it to the office.], [2],
    [coffee + mail], [Get a coffee and pick up the mail, in either order, then deliver both to the office.], [4],
    [patrol], [Visit room A, then room B, then room C, then room D, in that order.], [4],
    [b then coffee], [First check in at room B, then get a coffee, then bring it to the office.], [3],
    [mail then home], [Pick up the mail, deliver it to the office, and then go back to room A.], [3],
    table.hline(stroke: 0.8pt),
  ),
  caption: [Tasks used in Experiments 1 and 2. All tasks except _patrol_ add "Never step on a decoration." "States" is the number of non-terminal states in the true reward machine.],
) <tab:tasks>
]

All agents use tabular Q-learning with learning rate $alpha = 0.5$, discount $gamma = 0.9$, $epsilon$-greedy exploration with $epsilon = 0.1$ and episodes of at most 100 steps starting from a random free cell. Each run lasts 150,000 steps. Every 2,500 steps the greedy policy is evaluated from ten fixed start cells, and success is always measured against the true task, whatever machine the agent was trained with. Each condition were run with ten seeds.

== Experiment 1: structure versus knowledge

The experiment compares five main conditions that differ in how task knowledge reaches the agent (@tab:conditions). The key condition is the control, _flat + numeric_. It receives the same task knowledge as the reward machine agents, written by hand as a potential-based shaping function @ng1999. The potential grows as the agent approaches the next subgoal and as fewer subgoals remain. So it has the knowledge without the automaton. If it matches the reward machine agents, the benefit comes from the knowledge. If it doesn't, the symbolic form contributes something.

#[
#set par(justify: false)
#figure(
  table(
    columns: (auto, 1fr, 1fr),
    inset: (x: 6pt, y: 5pt),
    align: left + horizon,
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header[*Condition*][*Agent memory*][*Learning signal*],
    table.hline(stroke: 0.5pt),
    [flat], [Set of events seen so far], [True sparse reward],
    [flat + numeric], [Set of events seen so far], [True reward plus hand-written numeric shaping],
    [RM], [Reward machine state], [Reward machine],
    [RM + shaping], [Reward machine state], [Reward machine plus shaping computed from the machine],
    [CRM], [Reward machine state], [Reward machine with counterfactual updates],
    [CRM, swapped], [Corrupted machine state], [Machine with two subgoals swapped],
    [CRM, no avoid], [Corrupted machine state], [Machine without the decoration constraint],
    table.hline(stroke: 0.8pt),
  ),
  caption: [Conditions in Experiment 1. The last two use deliberately wrong machines.],
) <tab:conditions>
]

#[
#set par(justify: false)
#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr),
    inset: (x: 6pt, y: 5pt),
    align: (left + horizon, center + horizon, center + horizon, center + horizon, center + horizon, center + horizon),
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header[*Task*][*flat*][*flat + numeric*][*RM*][*RM + shaping*][*CRM*],
    table.hline(stroke: 0.5pt),
    [coffee], [21.3], [12.5], [7.5], [*5.0*], [7.5],
    [mail], [21.3], [12.5], [8.8], [*5.0*], [*5.0*],
    [coffee + mail], [42.5], [16.3], [21.3], [*7.5*], [*7.5*],
    [patrol], [never], [never], [never], [42.5], [*16.3*],
    [b then coffee], [never], [102.5 (8)], [never], [*12.5*], [15.0],
    [mail then home], [87.5 (9)], [32.5], [48.8], [8.8], [*7.5*],
    table.hline(stroke: 0.8pt),
  ),
  caption: [Thousands of training steps until the greedy policy first reaches 90% success, median over the seeds that reach it. A number in brackets gives the seeds out of ten that reached it when not all did; "never" means no seed did within 150,000 steps. The fastest condition is in bold.],
) <tab:exp1>
]

@tab:exp1 and @fig:exp1-main and @fig:exp1-new show the results. Four findings stand out.

*Structure with exploitation learns fastest on every task.* CRM reaches 90% success within 5,000 to 16,300 steps on every task, and RM with shaping is as fast or faster on all but _patrol_. On the tasks the flat agent solves at all, this is between about three and twelve times faster. On _patrol_ and _b then coffee_ the flat agent never succeeds.

*Numeric knowledge recovers part of the benefit on short tasks.* With the same task knowledge as a shaping function, the control learns _coffee_, _mail_ and _coffee + mail_ in 12,500 to 16,300 steps. That's much faster than the flat agent but still slower than CRM. On the ordered tasks it does much worse. It never solves _patrol_, and it solves _b then coffee_ in only eight of ten seeds after more than 100,000 steps. So part of the task knowledge's value can be delivered without an automaton, but not all of it.

*The machine state alone is not enough.* The plain RM agent uses the machine's state as memory and its reward but doesn't exploit its structure. It fails _patrol_ and _b then coffee_ entirely and is slow on _mail then home_. The benefit on long tasks comes from counterfactual updates or shaping, not from the abstract state. This matches the finding of Camacho et al. on robotic manipulation, where the abstract state helped on a short task but not a longer one, and shaping was needed @camacho2021.

*The reward machine's advantage is partly an advantage of memory.* The flat and control agents remember which events they have seen but not in what order. On _patrol_ this memory can't distinguish visiting A then B from visiting B then A. The control's shaping is computed from the same unordered memory, so it can reward progress that the true task does not count. The control's failure on ordered tasks is therefore partly a failure of its memory. This is an honest limit of the experiment, but it also illustrates a point in favour of the symbolic form. A reward machine supplies the right memory and the right signal together, while a hand-written numeric substitute must get both right separately.

#figure(
  image("../graphics/exp1-main.svg", width: 100%),
  caption: [Experiment 1 on the three short tasks. Success rate of the greedy policy, mean over ten seeds.],
) <fig:exp1-main>

#figure(
  image("../graphics/exp1-new.svg", width: 100%),
  caption: [Experiment 1 on the three longer ordered tasks. Success rate of the greedy policy, mean over ten seeds.],
) <fig:exp1-new>

== Experiment 1: wrong knowledge

To measure the cost of wrong knowledge, the CRM agent was also trained with two corrupted machines. The _swapped_ machine exchanges the events of the first two subgoals, so that, for example, "coffee then office" becomes "office then coffee". The _no avoid_ machine drops the transitions that fail on decorations. @tab:corrupt and @fig:exp1-corrupt give the final success rates.

#[
#set par(justify: false)
#figure(
  table(
    columns: (auto, 1fr, 1fr, 1fr, 1fr),
    inset: (x: 6pt, y: 5pt),
    align: (left + horizon, center + horizon, center + horizon, center + horizon, center + horizon),
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header[*Task*][*CRM, true machine*][*CRM, swapped*][*CRM, no avoid*][*flat*],
    table.hline(stroke: 0.5pt),
    [coffee], [1.00], [0.22], [0.62], [1.00],
    [mail], [1.00], [0.23], [0.51], [1.00],
    [coffee + mail], [1.00], [0.03], [0.58], [1.00],
    [patrol], [1.00], [0.27], [n/a], [0.00],
    [b then coffee], [1.00], [0.16], [0.00], [0.00],
    [mail then home], [1.00], [0.46], [0.43], [0.65],
    table.hline(stroke: 0.8pt),
  ),
  caption: [Final success rate after 150,000 steps, mean over ten seeds, measured against the true task. _Patrol_ has no decoration constraint, so the no-avoid corruption does not apply.],
) <tab:corrupt>
]

A wrong machine is worse than no machine on every task that the flat agent can learn. Swapping two subgoals reduces success on the short tasks from 1.00 to between 0.03 and 0.23, and the agent has no way to notice. It follows its machine faithfully and stops when the machine says the task is complete. Dropping the decoration constraint is less damaging but still costly, because the agent learns short paths that cross decorations. The single partial exception is informative. On _mail then home_ the swapped machine reaches 0.46, because the shortest route that satisfies the wrong order happens to pass through the cells the true order requires.

On the two tasks that the flat agent never learns, even a wrong machine does better than nothing (0.27 and 0.16 against 0.00), because the correct parts of its structure still guide exploration. So the cost of wrong knowledge depends on the alternative. It's severe when the task can be learned without help, and partly offset when it can't.

#figure(
  image("../graphics/exp1-corrupt.svg", width: 100%),
  caption: [CRM trained with the true machine and with two corrupted machines, compared with the flat agent. Success is measured against the true task.],
) <fig:exp1-corrupt>

== Experiment 2: reward machines written by a language model

Experiment 2 tests whether the hand-written machines of Experiment 1 can be replaced by machines generated from the plain-English descriptions in @tab:tasks. The prompt described the event alphabet, the meaning of a reward machine, the conventions for accepting and failing states, and the required JSON format, followed by one task description. Claude Sonnet 5 was queried five times per task through the Anthropic API with default settings, giving 30 machines. Each machine was checked for exact equivalence with the true machine by a breadth-first search over the product of the two automata. That search either proves that they give the same reward and terminate at the same time on every event sequence, or returns a counterexample. CRM agents were then trained on every generated machine with ten seeds.

All 30 machines were exactly equivalent to the true machines. The responses for each task differed only in surface form, with between one and four distinct responses per task. Because the generated machines were equivalent to the hand-written ones and had the same number of states, they produced identical learning updates. The agents trained on generated machines matched the hand-written CRM results in @tab:exp1 exactly, reaching 90% success at the same step on every task.

This is a ceiling result and you should read it as one. The tasks are short, the prompt fixes the event vocabulary and the conventions for failure, and the labelling function is given. The language model had to translate a clear sentence into a small automaton over a known alphabet. The harder steps of choosing what the events are and detecting them were done by hand. The experiment shows that this translation step is no longer a bottleneck for simple tasks, which supports the use of language models as a source of task structure (@sec:trends). It doesn't show that a language model can specify tasks whose events are ambiguous or must be discovered. Testing that requires longer tasks, under-specified descriptions and no conventions in the prompt.

== Experiment 3: reproducing NUDGE



Experiment 3 attempts to reproduce NUDGE on GetOut from its public code @delfosse2023 and then test the faithfulness of the learned rules. The planned test removes the five highest-weighted rules of a trained agent and measures the drop in return, compared with removing five low-weighted rules. If the readable top rules drive behaviour, the first ablation should cost far more than the second.

Running the public code on Colab required the changes listed in @tab:nudge-fixes before training could start. Several are likely to be caused by library versions that changed after publication rather than by errors in the original code, but each one had to be diagnosed from a stack trace. The number of changes is itself a finding about the reproducibility of neurosymbolic RL systems, which combine a logic engine, a neural library and a custom environment, each with its own dependencies.

#[
#set par(justify: false)
#figure(
  table(
    columns: (auto, 1fr),
    inset: (x: 6pt, y: 5pt),
    align: left + horizon,
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header[*Problem*][*Change made*],
    table.hline(stroke: 0.5pt),
    [Dependency conflicts], [Removed preinstalled packages that conflicted with the required numerical libraries],
    [Packages not installed], [Installed the logic engine and agent as editable packages],
    [Asset paths], [Normalised file paths when loading game sprites],
    [Environment interface], [Created the GetOut environment directly, bypassing an incompatible registration step],
    [Missing configuration], [Selected an existing rule set in the configuration file],
    [Stub reset], [Replaced a debugger breakpoint and an empty reset method with a working level generator],
    [Predicate names], [Renamed a rule predicate to match the name its valuation function is registered under],
    [Action format], [Mapped action names produced by the logic policy to the environment's action indices],
    table.hline(stroke: 0.8pt),
  ),
  caption: [Changes needed to run the public NUDGE code on Google Colab.],
) <tab:nudge-fixes>
]

//NOT TO SELF; TO PUT THE RESUKTS HERE AFTER THE NUDGE FINSIHES RUNNING

== Summary

The experiments supports the conditional verdict of @sec:evidence. When the symbolic knowledge is correct, a reward machine helps more than the same knowledge given as a hand-written shaping function, especially on long ordered tasks. The help comes from exploiting the machine's structure rather than from its state alone. When the knowledge is wrong, the agent follows it without noticing, and does worse than an agent with no knowledge at all on tasks it could have learned unaided. A language model can now write correct machines for simple tasks. That lowers the cost of providing correct knowledge but leaves the harder problem of choosing and detecting the symbols untouched.