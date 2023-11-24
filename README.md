# Flasher
This code is implemented in the paper [Selecting and Optimizing Origami Flasher Pattern Configurations for Finite-Thickness Deployable Space Arrays] (https://asmedigitalcollection.asme.org/mechanicaldesign/article/145/2/023301/1147307/Selecting-and-Optimizing-Origami-Flasher-Pattern).

Bolanos, D., Varela, K., Sargent, B., Stephen, M.A., Howell, L.L. and Magleby, S.P., 2023. “Selecting and Optimizing Origami Flasher Pattern Configurations for Finite‐Thickness Deployable Space Arrays.” Journal of Mechanical Design, 145(2), p.023301.

## Software
Matlab
JMP
Mathematica

## Description
The _flasher_ has gained attraction in the aerospace industry because of its capability to deploy to large areas while stowing in a small volume during launch. However, this pattern is complicated to design and understand the effects of changing design parameters. A tool developed by Robert Lang, _Tessellatica_, has facilitated the design process, however not much is known about how to optimize the pattern for a specific case scenario. 
<img width="162" alt="image" src="https://github.com/dianabolanos/flasher/assets/57923981/777eae38-24d1-4198-a8ec-3cba0151b58f">


### Analysis
A layout of the design variables and objectives are listed for context:

Design Variables:
Rotational order (m): Discrete [3 4 5 6 7]
Height order (h): Discrete [1 2]
Ring order (r): Discrete [1 2]
Separation (dr): Continuous [0 – 0.22]

Objective:
Maximize deployed incircle diameter

Subject to:
Stowed diameter < 0.5588
Stowed height < 0.3048

Given that analytical equations have not been fully developed for this pattern, we implemented the optimization by calling the Tessellatica Mathematica notebook directly (similar to utilizing a CFD software to evaluate models at varying parameters).

We chose to implement a genetic algorithm gradient-free approach because of the robustness of the approach. In addition, this method works well with mixed variable types, where both discrete and continuous variables can be used. We implemented this by mapping each variable on a binary base 2 scale. For discrete variable, this approach is easily implemented. However for the continuous separation (dr) variable, we chose to map each value between 0 and 0.22 with a 1e-4 step. 

The results of the genetic algorithm are shown below. Here we see that the function converges after about 15 generations to a deployed diameter (objective) of 2.39. The optimal design parameters provided after testing various iterations converge to m = 6, h = 2, r = 2, dr = 0.0054. 
<img width="333" alt="image" src="https://github.com/dianabolanos/flasher/assets/57923981/6bd07045-0a47-42c6-97be-fdc99ae560ae">

We learned about the difficulty introduced by integrating another software in the loop. Relying on interface with Mathematica caused delays in computation time. This was mitigated through a series of efforts, such as attempting to run parallel pooled computations and reducing the evaluations in the notebook. 
We made improvements along the way by tuning our methods to integrate well with the scope of the project, such as making decisions regarding which methods to use for mixed variable optimization. 

## Genetic Algorithm










