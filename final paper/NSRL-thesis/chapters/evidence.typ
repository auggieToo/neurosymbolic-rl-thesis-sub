#pagebreak()

= Critical comparison <sec:evidence>
\
\
This chapter looks at the question of whether neurosymbolic reinforcement learning is better than deep reinforcement learning, and if so, when (RQ3). We already know that deep reinforcement learning has some limitations ,to name a few ,  it's not very efficient, it doesn't generalize well, it's not safe, and it's hard to understand what is going on. The idea is that adding symbolic components can help with these issues. Most of the papers we looked at say that they've made some progress on at least one of these problems. So, in this chapter, we'll take a closer look at each of these claims, asking what they're comparing, what they're using as a baseline, and if there are other explanations for the results. We'll also think about what costs these claims might be leaving out, and then we'll summarize what we've found in a table.

== The knowledge confound

There's an issue that comes up in almost every comparison, and it's worth mentioning right away. When you're dealing with a neurosymbolic agent, it often has access to information that its deep RL baseline counterpart doesn't , things like a reward machine that outlines the task's subgoals, rules about which objects are important, safety specs, or a list of predicates. So, when the neurosymbolic agent learns faster or behaves more safely, there are two possible reasons why. It could be that the symbolic format of the knowledge is what's making the difference, or it might just be that any agent with the same knowledge would have performed just as well.

The difference is important when we're talking about RQ3. If we only consider knowledge, it's clear that informed agents perform better than uninformed ones , which isn't surprising and doesn't necessarily support symbolic methods. Deep RL has its own methods for using prior knowledge, such as reward shaping, curricula, and hand-designed features. A fair comparison for a neurosymbolic agent would be a deep RL agent that has access to the same knowledge in one of these forms. However, such comparisons are rare. Some papers on reward machines do compare themselves to hierarchical RL and shaping baselines that use the same task information, and Camacho et al. have separated the contribution of shaping from that of the abstract state. But most papers compare themselves to an uninformed agent. In our Experiment 1, we test this issue directly to see what really makes a difference.

== Sample efficiency

When it comes to tasks that have a sequence of steps, the best proof of effectiveness is how efficiently a system can learn. For example, in environments like OfficeWorld, CraftWorld, and WaterWorld, reward machines that use counterfactual updates can learn faster than other methods, as shown by @toroicarte2022. In another study, Camacho et al. found that using a reward machine reduced the number of training steps needed for a robot to learn a task from around 1,500 to just 200 steps @camacho2021. Similarly, SR-DQN has been shown to be more efficient than traditional reward machine methods, even when the rules are not perfect @veronese2026. Additionally, Kimura et al. reported that their system converged much faster on text-based games @kimura2021. These results suggest that using reward machines and related techniques can significantly improve the speed of learning in complex tasks.

Here's what's going on with these results,they all have a problem, but two of them can still work around it. When we look at the reward machine results, we see that the counterfactual updates are like a special tool, because they need the agent to be able to ask what the machine would do in every other situation. No matter how much shaping we add, it can't give us this.Camacho et al. states that just having the abstract state wasn't enough to help with the longer task, but shaping was. This shows that the benefit isn't just about having more state information. Our first experiment found the same thing.

== Generalisation

The results of generalization are really impressive in this field. For example, NUDGE agents did amazingly well on a tougher version of the game GetOut, scoring 3.60, while a neural PPO agent that was trained on the original version scored a much lower -20.88, as seen in @delfosse2023. Similarly, on some modified Atari games, the neural PPO agent scored zero, but BlendRL agents scored pretty high - 187, 113, and 263, according to @shindo2025. These numbers show just how well these agents can generalize and perform in different situations.

When you take a closer look at these results, you'll see that the authors have made some changes to the game. They've altered the way it looks or how things are arranged, but they've made sure that the underlying rules and relationships between objects stay the same. This is important because it means that the policies the authors have set up, which are based on how objects relate to each other, won't be affected by these changes. The emulator helps extract the objects and their relationships, so that part of the process doesn't get messed up either. What this shows is that the way the system understands the game is stable and doesn't change, even when the game's appearance does. However, it doesn't necessarily mean that the system has learned to adapt to new situations. To really test that, you'd need to make changes that affect the underlying relationships or add new objects that the system isn't familiar with. For example, a system called DUA, which has to find its own objects, struggles when it encounters transparent objects that its detector can't see.

When we compare different methods, the deep RL baselines are usually trained on just one version of the game. They don't use data augmentation or domain randomisation, which are techniques that deep RL practitioners use to make their models more robust. What this comparison shows is that symbolic policies work better when transferred than pixel policies that aren't regularised. But it's worth noting that this doesn't necessarily mean they work better than deep RL overall - just that they have an advantage over unregularised pixel policies.

== Safety

When it comes to safety, symbolic methods have an edge over deep RL. They can give you a solid guarantee, rather than just a likelihood. Think of it like a shield that stops any action that goes against its rules, as long as it has a correct understanding of the environment, as shown by @alshiekh2018. This approach has been tested in puzzles with constraints, where neurosymbolic action masking has reported almost no violations, according to @han2026.  It's not just limited to certain situations, probabilistic logic shields can even handle uncertain perceptions, as seen in @yang2023. This means you can have more confidence in the safety of your system.

The boundaries we're working with are outlined in @sec:open. Our guarantee only applies to the symbolic part, and its accuracy relies on how we perceive whether a certain rule applies or not. The baseline standards we're using are also not as strong as they could be. Constrained MDPs provide a solid framework for deep RL to balance rewards against constraint costs, as seen in @altman1999. However, it's less common to compare against constrained RL, and instead, we often compare against unconstrained agents - which isn't really fair, since they were never taught to follow those rules in the first place. So, the reasonable conclusion is that symbolic constraints are a better choice when we can define the rule exactly and can't afford to break it during training, because constrained RL can only promise to follow the rules on average, and even that's only after it's learned from its mistakes.

== Interpretability

One of the biggest advantages of interpretability is that it's supposed to make things easier to understand, but surprisingly, it's not often measured. We can see this in things like logic policies, programs, and rules that are easy to read, for example, NUDGE's rule for jumping over enemies, as shown by @delfosse2023. However, Doshi-Velez and Kim argue that interpretability should be judged on whether people can actually use the explanations to predict or correct the system's behavior, as they mentioned in @doshivelez2017. Unfortunately, not many papers on neurosymbolic RL have tried to evaluate this.

Another important question is whether the rules that are easy to understand are actually what's driving the agent's decisions. In some cases, like with weighted logic policies, lots of rules are contributing but with small weights, and the rules that are easiest to read might not be the ones that have the most influence. And with blended policies, the agent might be relying on its neural component in the situations that really matter, as we saw in @shindo2025. Even with distillation, the readable part is just an approximation of a policy that's still not transparent, as @bastani2018 pointed out. Rudin's argument that we should be using models that are interpretable from the start only works if the readable model is the one that's actually making the decisions, as @rudin2019 said. One way to test if the rules are really driving the agent's behavior is to remove the most important ones and see what happens, but this doesn't happen often. In Experiment 3, we tried to do just that with NUDGE, as you can see in @sec:experiments.

== Costs the comparisons leave out

The results that are reported describe what a neurosymbolic agent achieves. There are four costs that people do not report very often.

*Building a system.* Every project in @sec:methods requires a set of symbols, and usually needs even more: templates for rules, a special language, a machine that decides rewards, or a clear plan. This work is often overlooked when comparing how efficiently systems learn from examples, even though creating a good reward machine can take more time than training a system without it. It's a lot of work.

*The problem with bad information.* When a system relies on its internal symbols, it also inherits their mistakes. If the reward system is flawed, it will give false confidence to the learning process, and a wrong rule can only be corrected if the system is designed to handle it. Some systems, like SR-DQN, are built to handle imperfect rules by gradually reducing their impact, as seen in @veronese2026. However, most systems don't have this capability, and not many studies look at what happens when the information is incorrect. Our first experiment takes a closer look at this issue.

*Performance limits.* When we make a policy easier to understand, it can slow things down. DeRAN can get back around 78% to 87% of the speed of the complex policies it simplifies, as seen in @lu2026. For a network controller that needs to be transparent, this might be a fair trade-off, but it's still a trade-off.

*Reproducibility.* When you're working with neurosymbolic systems, you've got a lot of different parts to consider - logic engines, neural libraries, and custom environments, to name a few. Each of these components can cause problems with version conflicts and undocumented assumptions. For instance, when we tried to reproduce the results in @sec:experiments, we had to make several changes before we could get the public NUDGE code to work. This is pretty consistent with the bigger issues we've seen in @sec:open, where evaluating these systems can be a real challenge.

== Verdict

@tab:evidence gives us a summary of the assessment. It looks like the evidence backs up a conditional answer to RQ3. So, when is Neurosymbolic RL better than deep RL? Well, it's when the symbols are trustworthy, the task has a clear structure that the symbolic part gets right, and there's a need that deep RL can't fulfill on its own. This could be a strict rule during training, a policy that needs to be understood or changed, or applying what's learned to similar situations where known relationships stay the same. If all these conditions are met, the evidence is pretty convincing, even when we consider the potential bias in the knowledge.

Let's take a closer look at what the evidence really says about neurosymbolic RL. It turns out that most studies give the neurosymbolic agent an unfair advantage by providing it with more knowledge than its baseline. They also test its ability to generalize in situations where its abstraction doesn't change, and then claim it's more interpretable without actually measuring it. But here's the thing: there's hardly any evidence to support the use of neurosymbolic RL in areas where symbols need to be learned from raw perception - and that's exactly where deep RL shines. As the field is constantly evolving, it's possible that the conclusions drawn from these studies may not apply to the current state of deep RL.


#[
#set par(justify: false)
#set text(size: 9.5pt)
#figure(
  table(
    columns: (0.95fr, 1.6fr, 0.7fr, 1.6fr),
    inset: (x: 5pt, y: 5pt),
    align: left + horizon,
    stroke: none,
    table.hline(stroke: 0.8pt),
    table.header[*Claim*][*Best evidence*][*Strength*][*Main caveat*],
    table.hline(stroke: 0.5pt),
    [Sample efficiency], [Reward machines with counterfactual updates @toroicarte2022, machine-based shaping @camacho2021], [Strong], [Baselines often lack the same task knowledge],
    [Generalisation], [NUDGE and BlendRL on modified games @delfosse2023 @shindo2025], [Moderate], [Modifications preserve the relations the rules use; objects are given],
    [Safety], [Shields and action masking @alshiekh2018 @han2026], [Strong, within scope], [Guarantee covers the symbolic model, not perception],
    [Interpretability], [Readable rules and programs @delfosse2023 @lu2026], [Weak], [Rarely evaluated with users; faithfulness seldom tested],
    table.hline(stroke: 0.8pt),
  ),
  caption: [Summary of the evidence for the four main claims made for neurosymbolic RL.],
) <tab:evidence>
]
