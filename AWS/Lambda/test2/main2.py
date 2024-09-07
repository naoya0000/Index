import pkg_resources

def lambda_handler(event, context):
    installed_packages = [d.project_name for d in pkg_resources.working_set]
    print(installed_packages)
