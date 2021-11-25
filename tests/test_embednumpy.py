import pytest
import subprocess as sp
import shutil, platform, os
from pathlib import Path

def test_embednumpy():
	sp.run(['./testembednumpy'],check=1)

