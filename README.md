# TP Promela

## Installation

You need to install the following packages:

* [Spin](http://spinroot.com/spin/whatispin.html)
```bash
sudo apt install spin
```
* [GCC](https://gcc.gnu.org/)
```bash
sudo apt install gcc
```

## Usage

You can find a script named `macro.sh` in the root of the project. This script is used to quickly and easierly run the different models. The best way to use it is to add it to your `.bashrc` file.

```bash
cat macro.sh >> ~/.bashrc
```

Then you can use it like this:
* To run a model:
```bash
promel-sim <model_name>
```

* To verify a model:
```bash
promel-verif <model_name>
```
## Models

* [TP1](TP1/sujet_TP1_Promela_v2.pdf)
  * [Decker algorithm](TP1/tp1ex1.pml)
  * [Dijkstra semaphore](TP1/tp1ex2.pml)
  * [Loop in promela](TP1/tp1ex3.pml)
  * [Random numbers](TP1/tp1ex4.pml)