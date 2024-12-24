/*******************************************************************************
 * @file  /HexagonaArchitectureDemo/src/application/ports/driven/ForGettingTaxRate.h
 *
 * @brief
 *
 * @details
 *
 *

 *
 *
 * @author afardin  @date 22 dic 2024
 ******************************************************************************/

#ifndef SRC_APPLICATION_PORTS_DRIVEN_FORGETTINGTAXRATE_H_
#define SRC_APPLICATION_PORTS_DRIVEN_FORGETTINGTAXRATE_H_

class ForGettingTaxRate
{
  public:
    virtual float getTaxRate(float amount) const = 0;
    virtual ~ForGettingTaxRate()                 = default;
};

#endif /* SRC_APPLICATION_PORTS_DRIVEN_FORGETTINGTAXRATE_H_ */
