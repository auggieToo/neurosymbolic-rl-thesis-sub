#pagebreak()

= Application Domains <sec:domains>
\
\
This chapter addresses RQ2: in which application domains has neurosymbolic RL been used, and what properties of a domain favour it? The chapter doesn't attempt a complete catalogue. It groups the systems reviewed in @sec:methods by the kind of problem they were tested on, records where the symbols came from in each case, and then identifies the properties that the successful applications share. @tab:domains summarises the result.

_A caution applies throughout. Most systems are evaluated on benchmarks rather than deployed, so "application domain" usually means "the benchmark family a paper reports results on". Where a system has been used on a real problem, this is stated explicitly._

== Games and game-like benchmarks

Games are mostly the ones tested the most, for the same reasons they dominate deep RL as they are cheap to simulate, their rules are fixed and their scores give an unambiguous measure of performance. For neurosymbolic RL they have an additional advantage, which is that the objects of the game can be read from the game's memory instead of being detected in images.

The Atari suite is the main example. Deep RL agents learn Atari from pixels @mnih2015, while neurosymbolic agents increasingly receive object-centric states extracted from the emulator through OCAtari @delfosse2024oc. SCoBots, BlendRL and INSIGHT are all evaluated on Atari games in this form @delfosse2024 @shindo2025 @luo2024. SDRL was evaluated on Montezuma's Revenge, a game where sparse rewards and long sequences of subgoals defeat standard deep RL and where a symbolic plan over rooms, keys and doors supplies exactly the structure that is missing @lyu2019. Smaller logic-oriented games were designed specifically to test relational reasoning. NUDGE introduced environments such as GetOut, in which the agent must collect a key and reach a door while avoiding an enemy, and tested its policies on variants with more enemies or rearranged objects @delfosse2023.

Other game domains appear less often but are informative. PROLONETS was evaluated on two OpenAI Gym control tasks and two modified StarCraft II tasks, and found that rules supplied by untrained humans already raised the agent's expected reward before and after training @silva2021. LEAPS used the Karel domain, in which an agent moves through a grid and manipulates markers, because the domain comes with a programing language in which policies can be written @trivedi2021. PIRL learned programmatic policies for the TORCS car racing simulator @verma2018. Text-based games are a natural fit for logic, because their observations are already language. Kimura et al. extract first-order facts from the text observations of TextWorld, add word knowledge from ConceptNet, and train a policy built from logical operators that converges significantly faster than earlier neurosymbolic agents @kimura2021.



== Gridworlds with temporally extended tasks

A second group of benchmarks is designed to isolate task structure. The OfficeWorld, CraftWorld and WaterWorld domains used with reward machines contain tasks such as "get coffee, then bring it to the office" or crafting tasks that require materials to be collected in a particular order, where the reward depends on the order in which events happen @toroicarte2022. Furelos-Blanco et al. use similar domains to learn subgoal automata @furelosblanco2021, and SR-DQN reports its sample efficiency results on OfficeWorld-style tasks @veronese2026.

These domains are deliberately simple in perception. The agent's position and the events it triggers are given exactly. What they test is whether an agent can exploit sequential structure, and on that question they give clear answers. They also make controlled experiments cheap, which is why the experiments in @sec:experiments use a domain of this kind.

== Robotics and autonomous driving

Robotics is the domain most often named as the motivation for neurosymbolic RL, and the least often used for evaluation. Physical interaction is expensive, unsafe actions cause damage, and many robot tasks have an obvious sequential structure, all of which favour symbolic components. The difficulty is perception,e.g a robot must produce its symbols from cameras and sensors, and errors at that step propagate into the reasoning.

Reward machines have been applied to vision-based manipulation. Camacho et al. augmented a deep Q-learning agent with a reward machine for simulated pick-and-place tasks and compared the two signals the machine provides @camacho2021. The abstract machine state alone helped on a short stacking task but not on a longer kitting task, reward shaping from the machine helped substantially, and the combination outperformed every other configuration, needing about 200 training steps where shaping alone needed about 1,500. Code as Policies takes a different route and uses a language model to write executable control programs for tabletop manipulation and mobile robots @liang2023.

Autonomous driving combines sequential decisions with strict safety requirements, which makes it a natural target for constraints. Sharifi et al. combine deep RL with first-order logic rules for highway driving and report that the resulting agent avoids unsafe actions during both training and testing, converges faster than standard deep RL and generalises better to new highway scenarios @sharifi2023. Shielding was also developed with safety-critical control in mind @alshiekh2018. In both cases the guarantee holds relative to the vehicle's perception of other road users, which is supplied by a dataset or simulator in the reported experiments.

== Constrained decision problems

Some problems come with hard constraints that are known exactly in advance. Neurosymbolic action masking was evaluated on Sudoku, N-Queens, graph colouring and a visual varian tof Sudoku, where the rules of the puzzle define which actions are valid and violating them is the main way an agent fails @han2026. Probabilistic logic shields address the more realistic case where the constraint is known but whether it applies must be inferred from uncertain perception @yang2023. These domains show tge clearest benefit of symbolic constraints, because the constraint is both correct and complete by construction.

== Networks and operations

Operational domains offer the strongest case for interpretable policies, because a decision must often be audited before it is accepted. DeRAN applies neurosymbolic distillation to 5G radio access network control, converting deep RL policies into closed-form expressions and first-order rules that operators can inspect, while recovering 78% to 87% of the original performance @lu2026. Khandelwal et al. argue for the same domain class from the requirements side: when operating rules change, an agent whose constraints live in an editable knowledge graph can be updated without retraining @khandelwal2026. These are among the few cases where the motivation comes from a deployment requirement rather than a benchmark.

== Language models and program synthesis

A recent domain reverses the usual direction. Instead of symbolic knowledge helping an RL agent act in an environment, RL is used to train a language model and symbolic tools provide the reward. RLSF uses compilers and solvers to produce detailed feedback for fine-tuning, and reports large gains in compilation accuracy for code generation over supervised fine-tuning @jha2024. The symbols are here because a compiler error or a failed proof is already a precise, machine-checkable statement of what went wrong. This domain overlaps with the trend described in @sec:trends, where language models also act as a source of symbolic knowledge for RL agents.

#[
#set par(justify: false)
#set text(size: 9.5pt)
#figure(
  table(
    columns: (1.05fr, 1.3fr, 1.1fr, 1.25fr, 1.3fr),
    inset: (x: 5pt, y: 5pt),
    align: left + horizon,
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header[*Domain*][*Typical benchmarks*][*Main families*][*Source of symbols*][*Example systems*],
    table.hline(stroke: 0.5pt),
    [Games], [Atari via OCAtari, GetOut, Montezuma's Revenge, StarCraft II, TextWorld], [State, logic policies, high-level control], [Game memory, text], [@delfosse2023, @shindo2025, @lyu2019, @kimura2021],
    [Cognitive testbeds], [Animal-AI], [High-level control], [Hand-written detector], [DUA @mitchener2022],
    [Gridworlds], [OfficeWorld, CraftWorld, WaterWorld], [Reward structure, priors], [Exact labelling], [@toroicarte2022, @furelosblanco2021, @veronese2026],
    [Robotics], [Simulated manipulation], [Reward structure, programs], [Simulator, vision], [@camacho2021, @liang2023],
    [Driving], [Highway scenarios], [Action constraints], [Dataset, simulator], [@sharifi2023, @alshiekh2018],
    [Constrained problems], [Sudoku, N-Queens, graph colouring], [Action constraints], [Problem definition], [@han2026, @yang2023],
    [Networks], [5G radio access], [Programmatic policies], [Distilled from neural policy], [DeRAN @lu2026],
    [Language models], [Code generation], [Reward structure], [Compilers, solvers], [RLSF @jha2024],
    table.hline(stroke: 0.8pt),
  ),
  caption: [Application domains of neurosymbolic RL. "Source of symbols" records where the symbolic inputs came from in the reported experiments, not where they would come from in deployment.],
) <tab:domains>
]

== What favours a domain

The domains in @tab:domains differ widely, but the applications that report clear benefits share a small number of properties. These answer RQ2.

_Symbols are cheap and reliable._ In nearly every successful application the symbols are supplied rather than perceived: read from game memory, given by the gridworld, defined by the puzzle or produced by a compiler. The "Source of symbols" column of @tab:domains makes this visible. Where symbols must be detected, as in DUA, the system fails on exactly the cases its detector cannot handle @mitchener2022. A domain favours neurosymbolic RL to the extent that its relevant objects and events can be identified reliably.

_The task has sequential or compositional structure._ Reward machines, symbolic planners and hierarchical controllers help most when a task decomposes into ordered subgoals and the reward is sparse. Montezuma's Revenge, OfficeWorld and multi-step manipulation all have this property @lyu2019 @toroicarte2022 @camacho2021.

_Constraints are known in advance and violations are costly._ Shields and action masks give their strongest results when the constraint is exact, as in puzzles, or when the cost of a single violation is high, as in driving @han2026 @sharifi2023.

_Decisions must be inspected or changed._ Operational domains such as network control value a readable or editable policy enough to accept some loss in performance @lu2026 @khandelwal2026.

_The test distribution changes in ways that preserve the rules._ Logic policies and blended policies generalise to game variants with more enemies or moved objects, because their rules are stated over object relations rather than pixel patterns @delfosse2023 @shindo2025.

The converse is also  interestingly informative. No application reviewed here learns its symbolic vocabulary from raw perception in an open-ended environment, and the systems that need fine continuous control keep a neural component for it @shindo2025. Domains where the relevant concepts are unknown in advance, or where perception is the hard part of the problem, remain the territory of deep RL. Whether the benefits listed above outweigh the cost of providing the symbols is the question of @sec:evidence.