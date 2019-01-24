# Fencing: To put a fence between nodes, so that a failure in one of them does not affect the rest of nodes within the cluster

# The Fencing device, if is a physical machine, cannot share power with the node it controls !

# Working in a virtual environment, is just make sure the container running the Fencing device is not within same host as the node
# UH Project: It means you will need two hosts, two laptops perhaps ? Or just running the Fencing device within a VBox machine, although
# it means is still same physical machine, anyway, think about that.


