# Implications, Assertions, Pre- and PostConditions

## Recap of Implications

1. Do the Artemis task on Implications [w01t01](https://artemis.ase.in.tum.de/courses/253/exercises/9819)
   + Maybe try to draw the truth table for the implication operator if you are unsure about some cases.
   + Follow up: The *implication-operator* is syntactical sugar, how can you express it with more fundamental boolean operators?

2. Make sure you understand what it means for an Assertion to be *stronger* than another Assertion.
   + Follow up: How do Tautologies and Contradictions fit into this picture?

> **Important:**  Really try to understand how implications work, they are the foundation of all the following topics. Also try to get a feeling for the *Stronger* relation between Assertions, as they are the key to understanding the **WP-Calculus**.

## Assertions, Pre- and PostConditions

1. Remember what Assertions are and what they are used for in Program Verification. Do the task on Assertions [w01t02](https://artemis.ase.in.tum.de/courses/253/exercises/9832)
   + How does *coming up with Assertions* actually help me to proof something about my program?
   + How do seemingly arbitrary Assertions prove anything about my program?
     + Which two conditions must the Assertions satisfy to be a valid proof?
   + Which methods can we use to come up with new Assertions?

2. Do the task for Strongest Postconditions in the Repo
   + What is the criteria for proving a statement about a program with Strongest Postconditions?
3. Do the task for Weakest Preconditions in the Repo
   + What is the criteria for proving a statement about a program with Weakest Preconditions?
   + Why is this the preferred way of coming up with Assertions?
4. Do the task with the three small graphs in the Repo
5. Do the task for Local consistency in the Repo
   + What is the intuition behind local consistency?
   + What is the mathematical definition of local consistency?
   + Why didn't we need to proof local consistency in the WP-Calculus?

## Loop Invariants

1. Answer the following questions:
    + What is an Invariant?
    + What is the problem with loops in the WP-Calculus? Why does the normal algorithm not work?
    + How can we solve this problem?
  
2. Do the task loop_invariants_intro in the Repo
3. Do the task factorial in the Repo
4. Do the task simple_sum in the Repo
5. Do the task double_power in the Repo
6. Do the task power_sum in the Repo
7. Do the task the_first_strengthening in the Repo
8. Do the task the_second_strengthening in the Repo
9. Do the Artemis Suplemental Excercise [w04t01](https://artemis.ase.in.tum.de/courses/253/exercises/9886)

If you want to do more Loop Invariants, there are some in the subDirectory.

> **Note:**  Coming up with good Loop Invariants is hard. If you chose an Invariant that is too weak, the local consistency check will fail. If you chose an Invariant that is too strong, the proof fails because the program fails to achieve the preconditions needed for the Invariant (Basically you don't arrive at `true` at the beginning of the program).
>
> But even if figuring out Loop Invariants is hard, it is still a skill that you can learn with enough practice.
> Really try to understand the program, to a point where you can basically *predict* the values of the variables at each step of the program. This prediction is a good starting point for an Invariant.
> You also don't need come up with the correct Invariant on the first try, try to come up with weaker Invariants first and then strengthen them until it is just strong enough to pass the local consistency check.

There even exists an old lecture about how to come up with good Loop Invariants by Nico Hartmann. If you are interested you can watch it on <https://ttt.in.tum.de/recordings/Info2_2017_11_24-1/Info2_2017_11_24-1.mp4>. It is in German though.

## Termination

1. Answer the following questions:
    + Why is Termination important? Isn't it enough to just prove that the program is correct?
    + What is the process of creating a Termination proof?
    + Why does it work?

2. Do the task closer_to_zero in the Repo
3. Do the task what_about_b in the Repo
4. Do the task step_into_the_k-loop in the Repo
5. Do the Artemis Supplemental exercise [w04t02](https://artemis.ase.in.tum.de/courses/253/exercises/9887)

If you want to do more Termination proofs, there are some in the subDirectory.
