#import "@preview/classic-thesis-uct:0.1.4": *


#let custom-logo = none

#let custom-logo = image("graphics/uct.jpg", width: 43mm)

#let meta = (
  title: "Neurosymbolic Reinforcement Learning: How Symbolic Knowledge Reshapes the Learning Agent",
  logo: custom-logo,
  degree: "Bachelor Of Science",
  name: "Augustine Mochoeneng(MCHKOK003)",
supervisor:"Prof Shock",
co-supervisor:"",
  faculty: "Science Faculty",
  department: "Department of Applied Mathematics ",
  university: "University Of Cape Town",
  location: "Cape Town, South Africa",
  date: "November 2026",
  funder: "Funding body or 'N/A'",
)

#show: configure.with(meta)
#show pagebreak.where(to: "odd"): set page(header: none, footer: none)
#show pagebreak.where(to: "even"): set page(header: none, footer: none)
#set heading(numbering: "1.1")
#set cite(form: "normal")
#set bibliography(style: "ieee", title: none)
#show footnote.entry: set text(size: 8.5pt)
#show link: set text(fill: accent)
#show heading.where(level: 2): it => [
  #block(above: 1.65em, below: 1.45em)[
    #spaced-caps([
      #counter(heading).display(it.numbering)
      #h(0.85em)
      #it.body
    ], size: 9.5pt)
  ]
  #block(spacing: 0pt)[]
]
#show heading.where(level: 3): it => [
  #block(above: 1.65em, below: 1.45em)[
    #text(font: display-font, style: "italic", size: 8.5pt, tracking: 0.01em)[
      #smallcaps([
      #counter(heading).display(it.numbering)
      #h(0.85em)
      #it.body
      ])
    ]
  ]
  #block(spacing: 0pt)[]
]
#show heading.where(level: 4): it => [
  #block(above: 1.65em, below: 1.45em)[
    #pad(left: 1.6em)[
      #text(font: display-font, style: "italic", size: 8.5pt, tracking: 0.01em)[
        #smallcaps([
          #counter(heading).display(it.numbering)
          #h(0.85em)
          #it.body
        ])
      ]
    ]
  ]
  #block(spacing: 0pt)[]
]
#show heading.where(level: 5): it => [
  #block(above: 1.65em, below: 1.45em)[
    #pad(left: 1.6em)[
      #text(font: display-font, style: "italic", size: 8.5pt, tracking: 0.01em)[
        #smallcaps([
          #it.body
        ])
      ]
    ]
  ]
  #block(spacing: 0pt)[]
]

// Front matter (title page through Acronyms) uses a single column the same
// width as the major column but centred on the page, with no running header.
// The page number stays at the bottom but is true-centred (shift: 0mm)
// because the content area is no longer offset.
#set page(
  margin: (
    inside: front-matter-side-margin,
    outside: front-matter-side-margin,
    top: page-top-margin,
    bottom: page-bottom-margin,
  ),
  header: none,
  footer: folio-footer("i", shift: 0mm),
)

#title-page(meta)
//#title-back(meta)

#metadata(none)<end-front-matter>
#context if calc.odd(locate(<end-front-matter>).page()) {
  page(footer: none, numbering: none)[]
}
// Switch back to the mirrored two-side layout for the main matter:
// asymmetric inside/outside margins and the running chapter-title header.
#set page(
  margin: (
    inside: inner-margin,
    outside: outer-margin,
    top: page-top-margin,
    bottom: page-bottom-margin,
  ),
  header: classic-header(),
  footer: folio-footer("1"),
)
#counter(page).update(1)
#set text(font: "Libertinus Serif")
#show heading: set text(font: "Libertinus Serif")
#show math.equation: set text(font: "New Computer Modern Math")
#show raw: set text(font: "DejaVu Sans Mono")

#contents-page()
#include "chapters/introduction.typ"
#include "chapters/background.typ"
#include "chapters/taxonomies.typ"
#include "chapters/methods.typ"
#include "chapters/domains.typ"
#include "chapters/evidence.typ"
#include "chapters/experiments.typ"
#include "chapters/trends.typ"
#include "chapters/problems.typ"


= Conclusion <sec:conclusion>

This review set out to understand how symbolic knowledge reshapes the reinforcement learning agent. We organised the question around three research questions.

On RQ1, symbolic components now enter every part of the RL agent. Its state, its policy, its reward, its high-level control, its action space and its initialisation (@sec:methods). In almost every case they supplement the neural components rather than replace them. The neural part still perceives and acts at the lowest level, while the symbolic part supplies a vocabulary, a task structure, a plan or a constraint. Organising methods by the RL component they change, rather than by the direction of benefit, fits the field better than the existing taxonomies (@sec:taxonomies).

On RQ2, the domains where neurosymbolic RL succeeds share a small set of properties (@sec:domains). Their symbols are cheap and reliable. Their tasks have sequential or compositional structure. Their constraints are known in advance. Their decisions must be inspected or changed, or their test conditions vary in ways that preserve known relations. Games, gridworlds, constrained puzzles and operational settings such as network control fit this description. Open-ended domains where the relevant concepts must be learned from raw perception do not fit it, and they remain the territory of deep RL.

On RQ3, the answer is conditional (@sec:evidence). The evidence for sample efficiency and safety is strong when the symbolic knowledge is correct and the symbols are reliable. The evidence for generalisation is weaker than it appears, because the test modifications usually preserve the relations the symbolic policy depends on. And the evidence for interpretability is weakest of all, because it's rarely measured. Most comparisons also give the neurosymbolic agent knowledge its baseline lacks.

The experiments in @sec:experiments support this reading. A reward machine helped more than the same knowledge given as a hand-written shaping function, especially on long ordered tasks. The help came from exploiting the machine's structure rather than from its state alone. A wrong machine, however, did worse than no machine on every task the agent could learn unaided, and the agent had no way to notice. A language model wrote correct machines for every task tested, which lowers the cost of supplying correct knowledge without solving the harder problem of choosing and detecting the symbols. The attempt to reproduce NUDGE did not succeed within the available budget, which illustrates the reproducibility problem raised in @sec:evidence.


#bibliography-page(bibliography("references.bib"))