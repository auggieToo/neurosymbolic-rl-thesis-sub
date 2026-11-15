#pagebreak()
= Open problems <sec:open>
\
\


The trends in @sec:trends fix several of the limitations of deep RL that the introduction pointed out. They also leave big problems unsolved, and sometimes they create new ones. This chapter puts those problems into seven areas.

== Grounding symbols reliably

The symbol grounding problem (@sec:bg-grounding) is still the most fundamental obstacle. Most systems that report strong results get their symbols from a source you wouldn't have in a realistic deployment. DUA computes relations from bounding boxes using hand-written heuristics, and its colour-based detector can't detect transparent objects, so the agent fails every task that involves them @mitchener2022. Object-centric Atari benchmarks extract objects from the emulator rather than from images, which removes the perception problem instead of solving it @delfosse2024oc. When a learned detector produces the symbols, its errors propagate into the reasoning, and the reasoning has no way to recognise them.

End-to-end training (@sec:trends) is a partial answer, because errors in reasoning can then correct perception. It doesn't guarantee that the learned symbols mean what their names suggest, though. A predicate called `closeby` that's been trained only to improve return may come to encode something else entirely. That undermines the interpretability that motivated the symbolic component in the first place. Methods for checking that learned symbols stay faithful to their intended meaning are largely missing.

== Acquiring symbolic knowledge

Every neurosymbolic system needs rules, constraints or task structure from somewhere, and each available source has a weakness. Hand-written knowledge is accurate but slow to produce and hard to scale. Learned knowledge from ILP is accurate with respect to its examples, but the hypothesis space grows rapidly with the number of predicates and the length of rules @cropper2022. DUA's ILASP learning works because the abstract state space of its task is small. Differentiable logic avoids discrete search but requires you to fix the space of candidate rules with templates in advance @evans2018. LLM-generated knowledge is cheap and flexible @shindo2025 @liang2023, but nothing guarantees that a generated rule is correct, complete or consistent with the others. One promising but largely unexplored direction is to combine these sources. Use LLMs to propose rules and use ILP or formal verification to check them against data and specifications.

== Verification and guarantees

People often motivate neurosymbolic methods with verifiability, but the guarantees they provide are narrower than they look. A shield guarantees safety only with respect to its abstract model of the environment @alshiekh2018, and a probabilistic shield only with respect to the accuracy of its perception probabilities @yang2023. You can verify a decision tree extracted from a neural policy, but the tree only approximates the policy it came from, and the guarantee applies to the tree @bastani2018. In each case the formal guarantee covers the symbolic component. The neural components on either side of it, perception before and continuous control after, stay unverified. Acharya et al. identify the lack of verification and validation methods as a major gap @acharya2023. Closing it will require methods that bound the error of the neural components and carry those bounds through the symbolic reasoning.

== Evaluation and benchmarks

Right now it's hard to say whether neurosymbolic RL is better than conventional deep RL, because the evidence is spread across incompatible benchmarks. Recent papers evaluate on Animal-AI @mitchener2022, modified Atari games @shindo2025, custom logic environments @delfosse2023, gridworlds such as OfficeWorld @veronese2026 and combinatorial puzzles @han2026. Most are small or simplified, few are shared between papers, and baselines vary widely. Claims of interpretability are especially hard to assess. They usually rest on showing a readable rule rather than measuring whether people actually understand, predict or correct the agent's behaviour better. That's the standard Doshi-Velez and Kim argue interpretability research should meet @doshivelez2017. Colelough and Regli's finding that explainability and trustworthiness are among the least studied areas of neurosymbolic AI points the same way @colelough2024. Shared benchmarks that vary perception difficulty, task structure and distribution shift independently, together with user studies of interpretability, would make comparisons far more informative. This gap directly affects RQ3, and @sec:evidence examines the existing evidence with it in mind.

== Scalability and expressiveness

There's a recurring trade-off between how much a symbolic formalism can express and how efficiently you can use it. First-order logic and ASP can express rich relational knowledge, but ASP grounding can produce programs too large to solve when there are many objects @gebser2012, and ILP search scales poorly with expressiveness @cropper2022. Differentiable logic scales better with data but restricts the shape of rules. Reward machines are efficient but limited to regular languages. So most demonstrations use small symbolic vocabularies, a handful of predicates and short rules. Nobody has shown whether these methods keep their advantages in domains with hundreds of object types and long rule chains.

== Algorithms designed for neurosymbolic agents

Most neurosymbolic RL systems reuse standard RL algorithms, such as DQN, PPO or actor-critic methods, and attach a symbolic component to them. Acharya et al. argue that this is a limitation, since these algorithms don't account for the structure that symbolic components introduce @acharya2023. Open questions include how to assign credit through non-differentiable reasoning steps, how to explore efficiently when a symbolic component constrains which actions are available, and how to decide, as BlendRL does with its blending function @shindo2025, when an agent should trust its neural or its symbolic component. The learning-reasoning class, where both components update each other, is where this matters most. It's also the class with the fewest examples.

== Adaptation and self-monitoring

Finally, deployed agents face changing requirements and must know the limits of their own competence. Khandelwal et al. list open problems for editable specifications. How do you design specification languages that non-experts can edit safely? How do you infer the right edit from a natural-language request? What guarantees can an edit provide when the underlying policy was trained under different rules @khandelwal2026? A related and almost unexplored question is meta-cognition. That's the ability of an agent to monitor its own reasoning, detect when its symbols or rules no longer fit the situation, and adjust. Colelough and Regli found meta-cognition to be the least studied area of neurosymbolic AI, at 5% of the papers they reviewed @colelough2024. For RL agents operating in open environments, it may be one of the most important.