# Flasher
This code is implemented in the paper [Selecting and Optimizing Origami Flasher Pattern Configurations for Finite-Thickness Deployable Space Arrays](https://asmedigitalcollection.asme.org/mechanicaldesign/article/145/2/023301/1147307/Selecting-and-Optimizing-Origami-Flasher-Pattern).

Bolanos, D., Varela, K., Sargent, B., Stephen, M.A., Howell, L.L. and Magleby, S.P., 2023. “Selecting and Optimizing Origami Flasher Pattern Configurations for Finite‐Thickness Deployable Space Arrays.” Journal of Mechanical Design, 145(2), p.023301.

Credit to Robert Lang's [_Tessellatica_](https://langorigami.com/article/tessellatica/) notebook for initial work on flasher optimization.

## Software
* Matlab
* JMP
* Mathematica

## Description
The _flasher_ has gained attraction in the aerospace industry because of its capability to deploy to large areas while stowing in a small volume during launch. However, this pattern is complicated to design and understand the effects of changing design parameters. A tool developed by Robert Lang, _Tessellatica_, has facilitated the design process, however not much is known about how to optimize the pattern for a specific case scenario. 

<p align="center">
<img width="162" alt="image" src="https://github.com/dianabolanos/flasher/assets/57923981/777eae38-24d1-4198-a8ec-3cba0151b58f">
</p>

### Analysis
A layout of the design variables and objectives are listed for context:

**Design Variables:**
* Rotational order (m): Discrete [3 4 5 6 7]
* Height order (h): Discrete [1 2]
* Ring order (r): Discrete [1 2]
* Separation (dr): Continuous [0 – 0.22]


**Objective:**
* Maximize deployed incircle diameter


**Subject to:**
* Stowed diameter < 0.5588
* Stowed height < 0.3048

Given that analytical equations have not been fully developed for this pattern, we implemented the optimization by calling the Tessellatica Mathematica notebook directly (similar to utilizing a CFD software to evaluate models at varying parameters).

We chose to implement a genetic algorithm gradient-free approach because of the robustness of the approach. In addition, this method works well with mixed variable types, where both discrete and continuous variables can be used. We implemented this by mapping each variable on a binary base 2 scale. For discrete variable, this approach is easily implemented. However for the continuous separation (dr) variable, we chose to map each value between 0 and 0.22 with a 1e-4 step. 

The results of the genetic algorithm are shown below. Here we see that the function converges after about 15 generations to a deployed diameter (objective) of 2.39. The optimal design parameters provided after testing various iterations converge to m = 6, h = 2, r = 2, dr = 0.0054. 

<p align="center">
<img width="333" alt="image" src="https://github.com/dianabolanos/flasher/assets/57923981/6bd07045-0a47-42c6-97be-fdc99ae560ae">
</p>

We learned about the difficulty introduced by integrating another software in the loop. Relying on interface with Mathematica caused delays in computation time. This was mitigated through a series of efforts, such as attempting to run parallel pooled computations and reducing the evaluations in the notebook. 
We made improvements along the way by tuning our methods to integrate well with the scope of the project, such as making decisions regarding which methods to use for mixed variable optimization. 

## Genetic Algorithm
**Overview**

We chose to code the binary-encoded genetic algorithm (GA). We did this because we used a commercial GA optimizer as well.. We recognize that GA does take a lot longer to run to convergence than the other algorithms discussed in class. Because, however, we needed robustness because of the difficulty of implementing our objective function with mathematica, this seemed like the best option.

**Algorithm Implantation**

To develop the algorithm, we followed the pseudo-code highlighted in Dr. Ning’s book (Algorithm 7.5). A brief description for each of the steps in the pseudo-code is highlighted here.

**Initial Population Generation**

Objects for a population were created and the values for each of the design variables were randomly assigned. These values were represented in binary form which will be essential in later steps of the algorithm.

**Evaluation**

Each of the individuals in the population were then evaluated and the objective function value was stored for later steps.

**Selection Process**

Selection of the best individuals in the population was performed using the tournament method highlighted in Example 7.5 of the book. The individuals in the population were randomly paired and the one with the best fitness was chosen to proceed from the pairing. This occurred two times and the fittest winners from each tournament were taken and randomly paired for creating new individuals in the next generation of the algorithm. It should be noted here that because of the nature of our design problem, it was very important to handle constraint violations. We computed these violations using the approach highlighted in sections 7.6.3 of Dr. Ning’s book. Basically, if an individual had design variables that were outside the constraint range, the difference from the upper or lower bound of the constraints and the design variable was calculated and then normalized by the number of discrete values within the constraint range. The sum of all violations across all design variables for one individual were then taken and compared to the constraint violations of its opponent in the tournament. The individual with the lower constraint violation would always advance. In the case where one individual had constraint violations and its opponent didn’t, the one with no violations would always advance.

**Crossover Process**

Taking the “winning” pairs from the previous step, a mitosis-like splitting of these design variables of each individual in each pairing (the “parents”) was taken to create two new individuals to be used in the next generation. This splitting occurred as follows: A random integer was generated between one and one less than the number of bits for each design variable. The bits for each design variable were then split at the bit associated with this randomly generated number and crossed over with the second portions of bits from the second “parent” in the pairing. Doing this creates two new individuals which will be used in the population for the next “generation” of calculations. This process is much better explained in Dr. Ning’s book (section 7.6.1).

**Mutation Process**

These new “children” which make up the next generation of design considerations were then taken and random mutation was applied to each of the design variables. The mutation operated as follows: For each bit in each design variable, a random number was generated between zero and one. If that number was less than a very small pre-determined threshold (say 0.05), than the bit was flipped. If the number was not below the threshold, then nothing happened. This helps introduce an appropriate amount of “newness” to the population to explore even more of the design space. This process is also highlighted in section 7.6.1.

These steps in this process were implemented across a user-defined number of generations with the anticipation that the function value of the individuals in the population would converge closer to one another. 

**Results**

With the algorithm developed, we used it to evaluate our design problem just as we did with the commercial optimizer highlighted in the first few sections of this write-up. The results we found were very similar to what we saw from the commercial optimizer, but with two noticeable nuances. 

First if we look at a plot of the mean and max objective function value for the entire population at each generation we get the following plot:

<p align="center">
<img width="259" alt="image" src="https://github.com/dianabolanos/flasher/assets/57923981/0615b665-32e5-4096-8120-18eaecc16a15">
<img width="249" alt="image" src="https://github.com/dianabolanos/flasher/assets/57923981/e10712ac-397b-4073-93cd-bea20675ff45">
</p>

It can be seen here that our optimizer is a lot noisier across the generations than the commercial optimizer. This can especially be seen in the zoom-in seen above

Despite this, (looking at the average function value across generations) we see that convergence is reached just as we saw with the commercial optimizers. Reasons for this noise could possibly be coming from two different sources. First, the penalty method for the constraints is likely a lot more robust than ours which would keep things from jumping around like we see here. Second, it seems like based on the output from the commercial optimizer, that if particular individuals are not within the constraint functions that the design parameters will be adjusted and then rerun. This would smooth out the values seen here and cause it to look a lot more like the plot from the commercial optimizer. 

Another big difference we saw between our optimizer and the commercial optimizer was that our optimizer would converge to a lot larger range of values than the commercial optimizer. To understand what we mean by this better, consider the optimization of our design problem using a commercial optimizer. Running this optimization many different times, we would see variation in only one of our variables and that was the one with the largest range, dr. This value would range between 0.052 and 0.057, but the rest of the optimized design variables were always the same namely, m = 6, h = 2, r = 2. With our optimization however, we were seeing this small variation in dr across optimization runs, however values for m, h, and r were also varying. We ran our optimization 100 times and this is how the values for m, h, and r varied:

<!-- 
[m, h, r] Opt. Values	Number of Occurances	Total Number Runs	Percent of Occurances
[4, 1, 2]	9	100	9%
[4, 2, 2]	3	100	3%
[5, 1, 2]	15	100	15%
[5, 2, 2]	6	100	6%
[6, 2, 1]	4	100	4%
[6, 2, 2]	63	100	63%
-->


| [m, h, r] Opt. Values | Number of Occurances | Total Number Runs | Percent of Occurances | 
| ------------- | ------------- | ------------- | ------------- |
| [4, 1, 2]	| 9	| 100 |	9% |
| [4, 2, 2] |	3 |	100 |	3% |
| [5, 1, 2]	| 15	| 100	| 15% |
| [5, 2, 2]	| 6	| 100	| 6% |
| [6, 2, 1]	| 4	| 100	| 4% |
| [6, 2, 2]	| 63 | 100	| 63% |


The results match those of the commercial GA optimizer more than 60% of the time, but there is variance almost 40% of the time that were not seen in the commercial optimizer. One reasonable explanation for this is that the individuals are getting stuck in these other local minimums and not able to get out which is a combination of the random starting points and where the randomized crossover and mutation take the individuals. It should also be noted that a detailed analysis of dr at each of these configurations did not occur except for the 6, 2, 2 configurations. We did see that the range of variance for dr in this configuration was comparable to that seen in the commercial optimizer (0.0052 – 0.0063).
Looking at how the two algorithms differed in computational time, our developed optimizer had a lot more function calls than the commercial optimizer for a comparable population (40) and number of generations (80). The commercial optimizer had 2503 function calls while ours had 3200. Reduction in the function calls comes in part because the commercial optimizer had a min threshold before it ended, which our algorithm didn’t. This caused it to end about 10 generations earlier than the prescribed 80. However, in looking at the out log from the commercial code, it seems like their GA algorithms are additionally making some other adjustments in the background to reduce function calls. Additionally, if we just look at physical computational time, our optimizer took about 30 – 35 seconds to run (pop 40, 80 gen) and the commercial GA optimizer in MATLAB took about 15-20 seconds (also pop 40, 80 gen).

Explicitly stated, the best optimization we saw came from the design variables: M = 6, H = 2, R = 2, dr = 0.0052 with an objective function value of 2.4317.













