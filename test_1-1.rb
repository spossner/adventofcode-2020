require_relative 'test_helper'
require_relative '1-1'

class MyTest < TestCase
  def test_1
    assert_equal 241861950, expense_fix_3([1721,
    979,
    366,
    299,
    675,
    1456], 2020)
  end


  def test_puzzle
    assert_equal 200878544, expense_fix_3([1780,
                 1693,
                 1830,
                 1756,
                 1858,
                 1868,
                 1968,
                 1809,
                 1996,
                 1962,
                 1800,
                 1974,
                 1805,
                 1795,
                 170,
                 1684,
                 1659,
                 1713,
                 1848,
                 1749,
                 1717,
                 1734,
                 956,
                 1782,
                 1834,
                 1785,
                 1786,
                 1994,
                 1652,
                 1669,
                 1812,
                 1954,
                 1984,
                 1665,
                 1987,
                 1562,
                 2004,
                 2010,
                 1551,
                 961,
                 1854,
                 2005,
                 1883,
                 1965,
                 475,
                 1776,
                 1791,
                 262,
                 1912,
                 1227,
                 1486,
                 1989,
                 1857,
                 825,
                 1683,
                 1991,
                 1875,
                 1982,
                 1654,
                 1767,
                 1673,
                 1973,
                 1886,
                 1731,
                 1745,
                 1770,
                 1995,
                 1721,
                 1662,
                 1679,
                 1783,
                 1999,
                 1889,
                 1746,
                 1902,
                 2003,
                 1698,
                 1794,
                 1798,
                 1951,
                 1953,
                 2007,
                 1899,
                 1658,
                 1705,
                 62,
                 1819,
                 1708,
                 1666,
                 2006,
                 1763,
                 1732,
                 1613,
                 1841,
                 1747,
                 1489,
                 1845,
                 2008,
                 1885,
                 2002,
                 1735,
                 1656,
                 1771,
                 1950,
                 1704,
                 1737,
                 1748,
                 1759,
                 1802,
                 2000,
                 1955,
                 1738,
                 1761,
                 1765,
                 1853,
                 1900,
                 1709,
                 1979,
                 1911,
                 1775,
                 1813,
                 1949,
                 1966,
                 1774,
                 1977,
                 1757,
                 1992,
                 2009,
                 1956,
                 1840,
                 1988,
                 1985,
                 1993,
                 1718,
                 1976,
                 1078,
                 1997,
                 1897,
                 1792,
                 1790,
                 1801,
                 1871,
                 1727,
                 1700,
                 1485,
                 942,
                 1686,
                 1859,
                 1676,
                 802,
                 1952,
                 1998,
                 1961,
                 1844,
                 1808,
                 1703,
                 1980,
                 1766,
                 1963,
                 1849,
                 1670,
                 1716,
                 1957,
                 1660,
                 1816,
                 1762,
                 1829,
                 526,
                 359,
                 2001,
                 1874,
                 1778,
                 1873,
                 1511,
                 1810,
                 1699,
                 1970,
                 1690,
                 1978,
                 1892,
                 1691,
                 1781,
                 1777,
                 1975,
                 1967,
                 1694,
                 1969,
                 1959,
                 1910,
                 1826,
                 1672,
                 1655,
                 1839,
                 1986,
                 1872,
                 1983,
                 1981,
                 1972,
                 1772,
                 1760], 2020)
  end
end
