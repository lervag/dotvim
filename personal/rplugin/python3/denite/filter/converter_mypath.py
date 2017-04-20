from .base import Base
from os.path import expanduser, isabs, relpath
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

        for candidate in context['candidates']:
            new_word = relpath(candidate['word'], start=context['path'])
            if new_word[:2] != '..':
                candidate['word'] = new_word

        return context['candidates']
