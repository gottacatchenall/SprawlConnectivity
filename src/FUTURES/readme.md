A julia port of the _FUTURES_ model of urban growth (Meentemeyer et al 2012).

The original model is split into three components:

1. **Demand** models how much landscape will need to be
    converted into city/farmland to meet the growing population
    of a metro region. 

2. **Potential** models the intrinsic development potential of 
   each cell in the landscape. 

3. **Patch growing algorithm** models how cells transform from 
    undeveloped to developed, as a function of the Demand at a given
    timestep, the Potential of a cells development, and the distance 
    a cell is from other developed cells. Further, patch growing
    occurs as a function of Incentives, which modifies the development 
    potential of each cell based on a strategy for growth (increasing low density
    cells first before making new low density cells or vice-versa)

---

In order to implement this I've conceptually reframed these components


1. Potential

The intrinsic development potential of a cell $i$ is denoted $\gamma_i$. This
is estimated via logistic regression on environmental/socioeconomic/infrastructural predictors, $x$, and a dynamic development pressure index 
$\gamma_i$, which is the proportion of neighbors of a given cell that are developed. 

Logistic regression is done on developed cells at the first timestep to estimate $\alpha$ and $\beta$.

$\vec{\gamma} = \vec{\alpha} + \beta \Big(\vec{x} + \vec{p'}\Big)$

2. Demand 

Demand computes the needed amount of land needed at each timestep
based on statisitical estimate of the derivative of per-capita land-use 
at a given time.



3. Strategy

Strategy is controlled by a parameter $\chi$, which is applied to the potential value of each cell to get a $\gamma^\chi$

$\chi > 1$ implies infill,
$\chi = 1$ implies status-quo,
$\chi < 1$ implies sprawl 

4. Patch growing 

Draw seed proportional to development potential.

modify intrinsic development potential 

$d^\alpha$ where $d$ is the distance of the cell from the seed cell.