/*******************************************************************************
 * @file  /HexagonaArchitectureDemo/src/application/ports/driving/ForCalculatingTaxes.h
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

#ifndef SRC_APPLICATION_PORTS_DRIVING_FORCALCULATINGTAXES_H_
#define SRC_APPLICATION_PORTS_DRIVING_FORCALCULATINGTAXES_H_

class ForCalculatingTaxes
{
  public:
    virtual ~ForCalculatingTaxes()                = default;
    virtual float taxOn(const float amount) const = 0;
};

#endif /* SRC_APPLICATION_PORTS_DRIVING_FORCALCULATINGTAXES_H_ */
