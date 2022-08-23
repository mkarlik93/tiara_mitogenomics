
def get_input():
    return config["assembly_path"]

def get_run_name():
    return config["run_name"]

def get_min_length():
    return config["General_parameters"]["min_length"]

def get_temporary_directory():
    return config["General_parameters"]["temporary_directory"]

def get_database():
    return config["General_parameters"]["database"]

def get_assembly_name():
    return config["assembly_path"].split("/")[-1]
