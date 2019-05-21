#!/usr/bin/environment python3
import os
import yaml
import docker
try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper
from jinja2 import Template



HERE = os.path.dirname(__file__)
PARTIALS = os.path.join(HERE,'templates')
ASSEMBLY_OPTIONS = os.path.join(HERE,'options.yaml')


class BuildInstructions(object):
    """
    This just describes what is to be built and provides methods for writing docker files properly.
    """

    def __init__(self,base,ubuntu_version,python_version,tf_version,install_lab):
        self.base_image = base
        self.ubuntu_version = ubuntu_version
        self.python_version = python_version
        self.install_lab = install_lab
        self.tf_version = tf_version
        self.tensorflow = None
        if self.tf_version:
            if 'nvidia' in self.base_image:
                self.tensorflow = 'tensorflow-gpu=={}'.format(self.tf_version)
            else:
                self.tensorflow = 'tensorflow=={}'.format(self.tf_version)

    def __str__(self):
        return str(dict(
            base=self.base_image,
            ubuntu_version=self.ubuntu_version,
            python_version=self.python_version,
            tensorflow=self.tensorflow,
            install_lab = self.install_lab
        ))


    @property
    def docker_file_contents(self):
        """
        Generates a docker file based on the state of the object
        :return:
        """
        contents = []

        contents.append(load_template('ubuntu_version').render(ubuntu_version = self.ubuntu_version))
        contents.append(load_template(self.base_image).render())
        contents.append(load_template('ubuntu_all').render(ubuntu_version=self.ubuntu_version))
        contents.append(load_template('python').render(python_version=self.python_version))

        if self.tf_version:
            contents.append(load_template('tensorflow').render(tensorflow=self.tensorflow))

        if self.install_lab:
            contents.append(load_template('jupyter_lab').render())
        else:
            contents.append(load_template('no_jupyter_lab').render())

        contents.append(load_template('cleanup').render())
        return '\n'.join(contents)

    @property
    def image_name(self):
        processor = 'cpu'
        if 'nvidia' in self.base_image:
            processor = 'gpu'


        image_name = '-'.join([self.base_image,self.ubuntu_version,'py{}'.format(self.python_version)])

        if self.tf_version:
            image_name += '-tf{}'.format(self.tf_version)

        if self.install_lab:
            image_name += '-lab'

        return image_name





def load_template(name):
    """
    loads a partial template from disk and returns it as a Jinja template object

    :param name:
    :return:
    """
    path =  os.path.join(PARTIALS,'{}.partial.Dockerfile'.format(name))
    with open(path) as f:
        template = Template(f.read())
    return template

def compile_assembly_options(file):
    """
    Create docker files for each assembly option

    :param file:
    :return:

    """
    with open(file,'r') as f :
        assembly_options = yaml.load(f,Loader=Loader).get('options')


    for base in assembly_options.get('ubuntu_base'):
        for ubuntu_version in assembly_options.get('ubuntu_version'):
            for python_version in assembly_options.get('python_version'):
                for tf_version in assembly_options.get('tensorflow_version'):
                    for install_lab in assembly_options.get('lab'):
                        b = BuildInstructions(base,ubuntu_version,python_version,tf_version,install_lab)
                        with open(os.path.join('dockerfiles',b.image_name),'w') as f:
                            print(b.docker_file_contents,file=f)
                        yield b







def main():
    """
    Entry point for assembly script.
    """
    for image in compile_assembly_options(ASSEMBLY_OPTIONS):
        print(image)




if __name__ == '__main__':
    main()