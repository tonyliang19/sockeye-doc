# Process of building python package

Basically follow this official [doc](https://packaging.python.org/en/latest/tutorials/packaging-projects/)

To have isolated environment, use a Docker container to build the package and submit to Pypi.

Annotations:

- You might need to apt install something required for python venv, system will tell you
- You might encounter error like: `only one sdist may be uploaded per release` (problem with versioning and tar.gz)

Steps:

1. Make sure you at same directory of `pyproject.toml`
2. `python -m build`, this creates a dist dir that contains built files and informations, etc.
3. `python -m pip install --upgrade twine` (The upgrade is not required if twine exists already)
4. To upload it use any of the two options:
	+ `python -m twine upload --repository testpypi dist/*` (This one is for test purpose)
	+ If ready, use `python -m twine upload dist/*` (This is one uploads to actual pypi!)
	+ Both will ask you to enter username and password
