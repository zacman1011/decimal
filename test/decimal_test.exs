defmodule DecimalTest do
  use ExUnit.Case
  use Decimal.Record

  test "basic conversion" do
    assert Decimal.to_decimal(dec(coef: 0, exp: 0)) == dec(coef: 0, exp: 0)
    assert Decimal.to_decimal(123) == dec(coef: 123, exp: 0)
  end

  test "float conversion" do
    assert Decimal.to_decimal(123.0) == dec(coef: 123000000000000000000, exp: -18)
    assert Decimal.to_decimal(1.5) == dec(coef: 150000000000000000000, exp: -20)
  end

  test "string conversion" do
    assert Decimal.to_decimal("123") == dec(coef: 123, exp: 0)
    assert Decimal.to_decimal("+123") == dec(coef: 123, exp: 0)
    assert Decimal.to_decimal("-123") == dec(coef: -123, exp: 0)

    assert Decimal.to_decimal("123.0") == dec(coef: 1230, exp: -1)
    assert Decimal.to_decimal("+123.0") == dec(coef: 1230, exp: -1)
    assert Decimal.to_decimal("-123.0") == dec(coef: -1230, exp: -1)

    assert Decimal.to_decimal("1.5") == dec(coef: 15, exp: -1)
    assert Decimal.to_decimal("+1.5") == dec(coef: 15, exp: -1)
    assert Decimal.to_decimal("-1.5") == dec(coef: -15, exp: -1)

    assert Decimal.to_decimal("0") == dec(coef: 0, exp: 0)
    assert Decimal.to_decimal("+0") == dec(coef: 0, exp: 0)
    assert Decimal.to_decimal("-0") == dec(coef: 0, exp: 0)

    assert Decimal.to_decimal("1230e13") == dec(coef: 1230, exp: 13)
    assert Decimal.to_decimal("+1230e+2") == dec(coef: 1230, exp: 2)
    assert Decimal.to_decimal("-1230e-2") == dec(coef: -1230, exp: -2)


    assert Decimal.to_decimal("1230.00e13") == dec(coef: 123000, exp: 11)
    assert Decimal.to_decimal("+1230.1230e+5") == dec(coef: 12301230, exp: 1)
    assert Decimal.to_decimal("-1230.01010e-5") == dec(coef: -123001010, exp: -10)

    assert Decimal.to_decimal("0e0") == dec(coef: 0, exp: 0)
    assert Decimal.to_decimal("+0e-0") == dec(coef: 0, exp: 0)
    assert Decimal.to_decimal("-0e+0") == dec(coef: 0, exp: 0)
  end

  test "conversion error" do
    assert_raise ArgumentError, fn ->
      assert Decimal.to_decimal("")
    end

    assert_raise ArgumentError, fn ->
      assert Decimal.to_decimal("test")
    end

    assert_raise ArgumentError, fn ->
      assert Decimal.to_decimal(".0")
    end

    assert_raise ArgumentError, fn ->
      assert Decimal.to_decimal("e0")
    end

    assert_raise ArgumentError, fn ->
      assert Decimal.to_decimal("42.+42")
    end

    assert_raise ArgumentError, fn ->
      assert Decimal.to_decimal(:atom)
    end

    assert_raise ArgumentError, fn ->
      assert Decimal.to_decimal("42e0.0")
    end
  end

  test "abs" do
    assert Decimal.abs("123") == dec(coef: 123, exp: 0)
    assert Decimal.abs("-123") == dec(coef: 123, exp: 0)
    assert Decimal.abs("-12.5e2") == dec(coef: 125, exp: 1)
    assert Decimal.abs(dec(coef: -42, exp: -42)) == dec(coef: 42, exp: -42)
  end

  test "add" do
    assert Decimal.add("0", "0") == dec(coef: 0, exp: 0)
    assert Decimal.add("1", "1") == dec(coef: 2, exp: 0)
    assert Decimal.add("1.3e3", "2.4e2") == dec(coef: 154, exp: 1)
    assert Decimal.add("0.42", "-1.5") == dec(coef: -108, exp: -2)
    assert Decimal.add("-2e-2", "-2e-2") == dec(coef: -4, exp: -2)
  end

  test "to_string normal" do
    assert Decimal.to_string("0") == "0"
    assert Decimal.to_string("42") == "42"
    assert Decimal.to_string("42.42") == "42.42"
    assert Decimal.to_string("0.42") == "0.42"
    assert Decimal.to_string("0.0042") == "0.0042"
    assert Decimal.to_string("-1") == "-1"
    assert Decimal.to_string("-1.23") == "-1.23"
    assert Decimal.to_string("-0.0123") == "-0.0123"
  end

  test "to_string scientific" do
    assert Decimal.to_string("2", :scientific) == "2e0"
    assert Decimal.to_string("300", :scientific) == "3e2"
    assert Decimal.to_string("4321.768", :scientific) == "4.321768e3"
    assert Decimal.to_string("-53000", :scientific) == "-5.3e4"
    assert Decimal.to_string("0.0042", :scientific) == "4.2e-3"
    assert Decimal.to_string("0.2", :scientific) == "2e-1"
    assert Decimal.to_string("-0.0003", :scientific) == "-3e-4"
  end
end