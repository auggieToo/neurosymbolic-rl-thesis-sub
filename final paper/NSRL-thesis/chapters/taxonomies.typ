= Taxonomies for NeuroSymbolic integration <sec:taxonomies>

There is currently no single accepted way to classify a neurosymbolic systems. Different authors divide the field by different criteria. Some prominent criteria includees , how the neural and symbolic components are wired together, which compoenent helps the other, which capabilities the combination improves, or which task it is used for. A taxonomy matters, because it decides which systems are grouped together and therefore what comparisons a review makes. This chapter compares the main taxonomies (as of the writing of this), shows where each one helps or fails when applied to RL.

== Classification By architecture 

Kautz proposed one of the most widely cited classifications, based on how the two kinds of component are arranged @kautz2022. He distinguishes six patterns, written in a compact notation
- `Symbolic Neuro symbolic`: symbolic input is converted into vectors, processed by a neural network, and converted back into symbolic output. Most language models fall into this category.

- `Symbolic[Neuro]`: a symbolic problem solver calls a neural network as a subroutine, for example a planner or search procedure that uses a learned evaluation function.

- `Neuro | Symbolic`: a neural network turns perception into symbols that a separate symbolic reasoner then uses.

- `Neuro: Symbolic → Neuro`: symbolic knowledge is compiled into the training of a neural network, for example as training data or a regulariser, so that the knowledge ends up inside the network.

- `Neuro_Symbolic`: logical statements are encoded directly into the structure of a neural network.

- `Neuro[Symbolic]`: a neural system contains a symbolic reasoning engine that it can call when needed.

The strength of this classification is that it is precise about structure. Its weaknes (for RL) is that it says little about what the symbolic component does to the learning problem. DUA, for example, uses a perception module, a symbolic meta-policy and neural skills in sequence @mitchener2022, which fits `Neuro | Symbolic` for its first half and `Symbolic[Neuro]` for its second. A reward machine @toroicarte2022 fits none of the patterns well, because it changes the reward signal rather than the agent's architecture.

== Classification by direction of benefit

Yu et al. classify systems by which component helps the other @yu2023:

- In *learning for reasoning*, the goal is symbolic reasoning, and neural networks help by reducing the search space or turning raw data into symbols.
- In *reasoning for learning*, the goal is neural learning, and symbolic knowledge supports it, for example as constraints, priors or structure.
- In *learning-reasoning*, the interaction runs both ways and neither component is subordinate to the other.

Acharya et al. adopt this scheme for RL and add structural characteristics to each class: learning for reasoning is serial, with information flowing from the neural to the symbolic component; reasoning for learning is parallel, with symbolic knowledge flowing into the neural component; and learning-reasoning is bidirectional @acharya2023. They also list typical application areas for each class, such as transforming unstructured data into symbols for the first and reward shaping and programmatic policy design for the second.

This scheme is the most common way of organising neurosymbolic RL, and it captures something the architectural view misses: the _purpose_ of the integration. Its weakness is that the direction of benefit is often a matter of interpretation. Many systems pass information in both directions to some degree, and the class a system is placed in depends on which direction the author treats as primary. 

== Classification by capability

Sheth et al. take a different route and classify methods by how knowledge moves between the two components @sheth2023. In the first family, symbolic knowledge is _compressed_ into a form a neural network can use, either as knowledge graph embeddings or as compressed logic. In the second, neural patterns are _lifted_ into symbolic form so that symbolic reasoning can operate on them, either through a decoupled pipeline or through tightly intertwined components. For each of the sub-families they rate how well it supports algorithm-level capabilities (perception, abstraction, analogy, planning) and application-level ones (explainabiLity, domain constraints, scalability, continual learning).

The taxonomy links architecture to capabilities, which is closer to what a practitioner needs to know. Its ratings are qualitative, however, and it was not designed for RL. It has no category for knowledge that shapes the reward or constrains the action space, which are two of the most common uses of symbolic knowledge in RL.




== Clasification by task and  research area

More recent surveys move away from structural criteria altogether. Delvecchio et al. organise neurosymbolic methods by the task the symbolic component performs: _rule mining_ (extracting rules from data or from a trained network), _rule enforcement_ (imposing rules on a model's behaviour) and _program synthesis_ (generating executable programs) @delvecchio2025. Colelough and Regli classify research by area rather than method, into knowledge representation, learning and inference, logic and reasoning, explainability and trustworthiness, and meta-cognition @colelough2024.

A task-based view fits recent RL work well. Logic policies learned from object-centric states mine rules @delfosse2023, shields and action masks enforce them @yang2023 @han2026, and LLM-generated policies synthesise programs @liang2023. It is less suited to older hierarchical systems, in which the symbolic component plans rather than mining, enforcing or synthesising rules.

== Summary

@tab:taxonomies summarises the four approaches. Each answers a different question about a neurosymbolic system, and none is complete on its own for RL.
\
\


#[
#set par(justify: false)
#set text(size: 9.5pt)
#figure(
  table(
    columns: (1fr, 1fr, 1fr, 1.2fr),
    inset: (x: 6pt, y: 5pt),
    align: left + horizon,
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header[*Taxonomy*][*Question it answers*][*Strength for RL*][*Weakness for RL*],
    table.hline(stroke: 0.5pt),
    [Kautz @kautz2022], [How are the components wired?], [Precise about structure], [Silent on reward and action constraints; hybrid systems span several patterns],
    [Yu et al. @yu2023, Acharya et al. @acharya2023], [Which component helps which?], [Captures the purpose of integration], [Direction is often ambiguous; surveys disagree on placements],
    [Sheth et al. @sheth2023], [How does knowledge move, and what does it enable?], [Links design to capabilities], [Qualitative ratings; no RL-specific categories],
    [Delvecchio et al. @delvecchio2025], [What task does the symbolic part perform?], [Fits recent rule-based RL work], [Does not cover planning-based systems well],
    table.hline(stroke: 0.8pt),
  ),
  caption: [Four ways of classifying neurosymbolic systems, compared from the perspective of reinforcement learning.],
) <tab:taxonomies>
]
\
\
For the purposes of this review, the most useful question is the one posed in RQ1: *which part of the RL agent does the symbolic component change?* \@sec:methods therefore organises methods by RL component: the state representation, the policy, the reward, high-level control, the set of permitted actions, and the agent's initial knowledge. For each method, the class it belongs to in the scheme of Yu et al. is also recorded, so that the review remains comparable with existing surveys. This choice has two advantages. It maps directly onto the standard structure of an RL agent, so a reader can see what each method replaces or adds. It also avoids most of the ambiguity of the direction-based scheme: whatever one decides about the direction of benefit in DUA, it is clear that its symbolic component is a meta-policy over options.
