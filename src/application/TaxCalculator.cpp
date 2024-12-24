/*******************************************************************************
 * @file  /HexagonaArchitectureDemo/src/application/TaxCalculator.cpp
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

#include "TaxCalculator.h"

float TaxCalculator::taxOn(const float amount) const
{
    return amount * _taxRateRepository->getTaxRate(amount);
}
