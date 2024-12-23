#include "gtest/gtest.h"
#include "gmock/gmock.h"

#include <memory>
#include <string>
#include "application/TaxCalculator.h"

extern "C"
{
}

using namespace std;
using namespace testing;

class moduleTestenvironment : public ::testing::Environment
{
  public:
    ~moduleTestenvironment()
    {
    }

    // Override this to define how to set up the environment.
    void SetUp()
    {
    }

    // Override this to define how to tear down the environment.
    void TearDown()
    {
    }
};

testing::Environment *const module1Env = testing::AddGlobalTestEnvironment(new moduleTestenvironment);

class TaxCalculatorTest : public ::testing::Test
{
  protected:
    void SetUp() override
    {
    }

    void TearDown() override
    {
    }
};

class TestTaxRateRepository : public ForGettingTaxRate
{
  private:
    float _rate = 0.0f;

  public:
    TestTaxRateRepository() = default;
    explicit TestTaxRateRepository(float rate) : _rate(rate)
    {
        if(_rate < 0)
            throw std::invalid_argument("Tax Rate shoul be not negative");
    }

    float getTaxRate(float amount) const override
    {
        return _rate;
    }
};

TEST_F(TaxCalculatorTest, should_return_0_for_zero_tax_rate)
{
    auto taxRepo = std::make_unique<TestTaxRateRepository>(0.20);
    TaxCalculator taxCalc(std::move(taxRepo));

    float taxes = taxCalc.taxOn(100);

    ASSERT_EQ(20, taxes);
}

TEST_F(TaxCalculatorTest, should_throw_exception_for_negative_rate_with_correct_message)
{
    EXPECT_THROW(TestTaxRateRepository(-0.1f), std::invalid_argument);
}

TEST_F(TaxCalculatorTest, should_reject_negative_tax_rate)
{
    try
    {
        auto taxRepo = TestTaxRateRepository(-0.1f);
        FAIL() << "Expected std::invalid_argument";
    }
    catch(const std::invalid_argument &ex)
    {
        EXPECT_STREQ(ex.what(), "Tax Rate shoul be not negative");
    }
    catch(...)
    {
        FAIL() << "Expected std::invalid_argument";
    }
}
