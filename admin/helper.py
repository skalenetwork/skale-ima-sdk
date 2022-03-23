#   -*- coding: utf-8 -*-
#
#   This file is part of skale-ima-sdk
#
#   Copyright (C) 2022-Present SKALE Labs
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.


import os
import shutil
import logging


logger = logging.getLogger(__name__)


def rm_dir(folder: str) -> None:
    if os.path.exists(folder):
        logger.info(f'{folder} exists, removing...')
        shutil.rmtree(folder)
    else:
        logger.info(f'{folder} doesn\'t exist, skipping...')


