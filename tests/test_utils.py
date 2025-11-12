import pytest
from utils import calculate_sum


def test_calculate_sum_integers():
    """Test calculate_sum with integer inputs."""
    assert calculate_sum(2, 3) == 5
    assert calculate_sum(0, 0) == 0
    assert calculate_sum(-5, 10) == 5


def test_calculate_sum_floats():
    """Test calculate_sum with float inputs."""
    assert calculate_sum(2.5, 3.7) == 6.2
    assert calculate_sum(0.1, 0.2) == pytest.approx(0.3)


def test_calculate_sum_mixed():
    """Test calculate_sum with mixed int and float inputs."""
    assert calculate_sum(5, 3.5) == 8.5
    assert calculate_sum(10.2, 5) == 15.2

