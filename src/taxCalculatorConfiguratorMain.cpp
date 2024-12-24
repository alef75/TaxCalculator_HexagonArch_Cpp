/*******************************************************************************
 * @file  /HexagonaArchitectureDemo/src/taxCalculator.cpp
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
#include <cstdio>
#include "application/TaxCalculator.h"
#include "adapters/FixedTaxRateRepository.h"

int main()
{
    auto taxRepo = std::make_unique<FixedTaxRateRepository>();
    TaxCalculator taxCalc(std::move(taxRepo));

    float taxes = taxCalc.taxOn(100);

    printf("Total Tax to pay = %.02f\n", taxes);

    return 0;
}