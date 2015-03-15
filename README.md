# Cardio

A [Cython](http://cython.org/) wrapper around [Card.io](https://www.card.io/).

## Building

```bash
brew tap homebrew/python
brew tab homebrew/science
brew install homebrew/science/opencv
brew install pkg-config
pip install cython
pip install pillow
cd cardio
git submodule init
git submodule update
make
```

## Running

```bash
./run.py
```
