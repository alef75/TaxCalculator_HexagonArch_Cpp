/*******************************************************************************
 * @file  /HexagonaArchitectureDemo/src/adapters/FixedTaxRateRepository.h
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

#include "application/ports/driven/ForGettingTaxRate.h"

#ifndef SRC_ADAPTERS_FIXEDTAXRATEREPOSITORY_H_
#define SRC_ADAPTERS_FIXEDTAXRATEREPOSITORY_H_

class FixedTaxRateRepository : public ForGettingTaxRate
{
  public:
    float getTaxRate(float amount) const override;
};

#endif /* SRC_ADAPTERS_FIXEDTAXRATEREPOSITORY_H_ */
