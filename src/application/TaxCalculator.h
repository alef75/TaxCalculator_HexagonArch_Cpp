/*******************************************************************************
 * @file  /HexagonaArchitectureDemo/src/application/TaxCalculator.h
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

#ifndef SRC_APPLICATION_TAXCALCULATOR_H_
#define SRC_APPLICATION_TAXCALCULATOR_H_

#include <memory>
#include "ports/driving/ForCalculatingTaxes.h"
#include "ports/driven/ForGettingTaxRate.h"

class TaxCalculator : public ForCalculatingTaxes
{
  private:
    std::unique_ptr<const ForGettingTaxRate> _taxRateRepository;

  public:
    explicit TaxCalculator(std::unique_ptr<const ForGettingTaxRate> repository) : _taxRateRepository(std::move(repository))
    {
    }
    float taxOn(float amount) const override;
};

#endif /* SRC_APPLICATION_TAXCALCULATOR_H_ */
