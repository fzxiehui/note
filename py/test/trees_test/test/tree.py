#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import py_trees

from test_aviour import TestAviour

if __name__ == '__main__':

    
    # py_trees.logging.level = py_trees.logging.Level.DEBUG
    root = py_trees.composites.Parallel("Parallel")
    high = TestAviour('high')
    med = TestAviour('med')
    low = TestAviour('low')
    root.add_children([high, med, low])

    behaviour_tree = py_trees.trees.BehaviourTree(
        root=root
    )
    print(py_trees.display.unicode_tree(root=root))
    behaviour_tree.setup(timeout=15)

    def print_tree(tree):
        print(py_trees.display.unicode_tree(root=tree.root, show_status=True))

    try:
        behaviour_tree.tick_tock(
            period_ms=500,
            # number_of_iterations=py_trees.trees.CONTINUOUS_TICK_TOCK,
            number_of_iterations = 200,
            pre_tick_handler=None,
            post_tick_handler=print_tree
        )
    except KeyboardInterrupt:
        behaviour_tree.interrupt()
