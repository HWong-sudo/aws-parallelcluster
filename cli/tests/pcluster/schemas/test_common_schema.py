# Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance
# with the License. A copy of the License is located at
#
# http://aws.amazon.com/apache2.0/
#
# or in the "LICENSE.txt" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES
# OR CONDITIONS OF ANY KIND, express or implied. See the License for the specific language governing permissions and
# limitations under the License.
import pytest
from assertpy import assert_that

from pcluster.schemas.common_schema import validate_json_format


@pytest.mark.parametrize(
    "data, expected_value",
    [
        ('{"cluster": {"scheduler_slots": "cores"}}', True),
        ('{"cluster"}: {"scheduler_slots": "cores"}}', False),
    ],
)
def test_validate_json_format(data, expected_value):
    assert_that(validate_json_format(data)).is_equal_to(expected_value)
