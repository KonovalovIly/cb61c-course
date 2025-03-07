from distutils.core import setup, Extension
import sysconfig

def main():
    CFLAGS = ['-g', '-Wall', '-std=c99', '-fopenmp', '-mavx', '-mfma', '-pthread', '-O3']
    LDFLAGS = ['-fopenmp']
    # Use the setup function we imported and set up the modules.
    # You may find this reference helpful: https://docs.python.org/3.6/extending/building.html
    # TODO: YOUR CODE HERE
    # Define the module
    module = Extension(
        'numc',  # Name of the module
        sources=['numc.c'],  # Source files
        extra_compile_args=CFLAGS,
        extra_link_args=LDFLAGS
    )

    # Call the setup function
    setup(
        name='numc',  # Name of the package
        version='1.0',  # Version of the package
        description='A fast matrix operations library implemented in C',  # Description
        ext_modules=[module],  # List of extension modules
    )


if __name__ == "__main__":
    main()
