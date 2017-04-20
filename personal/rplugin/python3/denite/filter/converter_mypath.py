from .base import Base
from os.path import expanduser
import re


class Filter(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'converter_mypath'
        self.description = 'convert candidate word to relative path'

    def filter(self, context):
        for candidate in context['candidates']:
            split = re.split('\/Dropbox\/documents', candidate['word'])
            if len(split) > 1:
                candidate['word'] = expanduser('~/documents') + split[1]

        return context['candidates']
