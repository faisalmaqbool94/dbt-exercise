import pickle
import json

class Error(Exception):
    """Base class for other exceptions"""
    pass

class ContainsDanglingSourcesOrModels(Error):
    """Raised when there are dangling sources or models in the directed graph"""
    pass

def check_for_dangling_resources():
    try:
        with open('target/graph.gpickle', 'rb') as f:
            di_graph = pickle.load(f)
            nodes = di_graph.nodes

            dangling_nodes = [node for node in di_graph.__iter__() if len(list(di_graph.successors(node))) == 0 and len(list(di_graph.predecessors(node))) == 0]
            no_child_nodes = [node for node in di_graph.__iter__() if len(list(di_graph.successors(node))) == 0 and node not in dangling_nodes and 'exposure' not in node]

            if len(dangling_nodes) != 0 or len(no_child_nodes) != 0:
                print("sources or models that have no parent or child \n")
                print(json.dumps(dangling_nodes, indent = 4))
                print("Sources or models that have no child (not being used in any exposures or another model are \n")
                print(json.dumps(no_child_nodes, indent = 4))
                raise ContainsDanglingSourcesOrModels
            else:
                print("No dangling sources or models found")
    except Exception as e:
        raise

if __name__ == "__main__":
    check_for_dangling_resources()
