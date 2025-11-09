import React, { useState, useEffect } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Textarea } from '@/components/ui/textarea';
import { Mic, Save, Plus, Trash2 } from 'lucide-react';

const MobileWiki = () => {
  const [sections, setSections] = useState(() => {
    const saved = localStorage.getItem('wiki-sections');
    return saved ? JSON.parse(saved) : [
      { id: 'home', name: 'Home', content: '# Welcome\n\nYour wiki starts here.' },
      { id: 'lyrics', name: 'Lyrics', content: '# Lyrics\n\nAdd your lyrics here.' },
      { id: 'notes', name: 'Notes', content: '# Notes\n\nQuick notes and thoughts.' },
      { id: 'archive', name: 'Archive', content: '# Archive\n\nOld stuff goes here.' }
    ];
  });
  
  const [activeSection, setActiveSection] = useState('home');
  const [isListening, setIsListening] = useState(false);
  const [editMode, setEditMode] = useState(false);

  useEffect(() => {
    localStorage.setItem('wiki-sections', JSON.stringify(sections));
  }, [sections]);

  const currentSection = sections.find(s => s.id === activeSection);

  const updateContent = (content) => {
    setSections(sections.map(s => 
      s.id === activeSection ? { ...s, content } : s
    ));
  };

  const addSection = () => {
    const name = prompt('Section name:');
    if (name) {
      const id = name.toLowerCase().replace(/\s+/g, '-');
      setSections([...sections, { 
        id, 
        name, 
        content: `# ${name}\n\n` 
      }]);
      setActiveSection(id);
    }
  };

  const deleteSection = () => {
    if (sections.length > 1 && confirm(`Delete "${currentSection.name}"?`)) {
      const newSections = sections.filter(s => s.id !== activeSection);
      setSections(newSections);
      setActiveSection(newSections[0].id);
    }
  };

  const startVoiceNav = () => {
    if (!('webkitSpeechRecognition' in window)) {
      alert('Voice not supported in this browser');
      return;
    }

    const recognition = new webkitSpeechRecognition();
    recognition.continuous = false;
    recognition.interimResults = false;

    recognition.onstart = () => setIsListening(true);
    recognition.onend = () => setIsListening(false);

    recognition.onresult = (event) => {
      const transcript = event.results[0][0].transcript.toLowerCase();
      
      // Find section by name
      const section = sections.find(s => 
        transcript.includes(s.name.toLowerCase())
      );
      
      if (section) {
        setActiveSection(section.id);
      } else if (transcript.includes('new') || transcript.includes('add')) {
        addSection();
      } else if (transcript.includes('edit')) {
        setEditMode(true);
      } else if (transcript.includes('save')) {
        setEditMode(false);
      }
    };

    recognition.start();
  };

  const renderContent = () => {
    if (!currentSection) return null;

    // Simple markdown rendering (basic bold, headers, lists)
    const lines = currentSection.content.split('\n');
    return lines.map((line, i) => {
      if (line.startsWith('# ')) {
        return <h1 key={i} className="text-3xl font-bold mb-4 mt-6">{line.slice(2)}</h1>;
      } else if (line.startsWith('## ')) {
        return <h2 key={i} className="text-2xl font-bold mb-3 mt-4">{line.slice(3)}</h2>;
      } else if (line.startsWith('### ')) {
        return <h3 key={i} className="text-xl font-bold mb-2 mt-3">{line.slice(4)}</h3>;
      } else if (line.startsWith('- ')) {
        return <li key={i} className="ml-6 mb-1">{line.slice(2)}</li>;
      } else if (line.trim()) {
        return <p key={i} className="mb-2">{line}</p>;
      } else {
        return <br key={i} />;
      }
    });
  };

  return (
    <div className="min-h-screen bg-gray-900 text-gray-100">
      {/* Top Navigation Bar */}
      <div className="sticky top-0 bg-gray-800 border-b border-gray-700 z-10">
        <div className="overflow-x-auto">
          <div className="flex p-2 gap-2 min-w-max">
            {sections.map(section => (
              <Button
                key={section.id}
                variant={activeSection === section.id ? "default" : "ghost"}
                onClick={() => setActiveSection(section.id)}
                className="whitespace-nowrap"
              >
                {section.name}
              </Button>
            ))}
            <Button
              variant="ghost"
              size="icon"
              onClick={addSection}
            >
              <Plus className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="p-4 max-w-4xl mx-auto">
        <Card className="bg-gray-800 border-gray-700">
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle className="text-2xl">{currentSection?.name}</CardTitle>
            <div className="flex gap-2">
              <Button
                variant="ghost"
                size="icon"
                onClick={startVoiceNav}
                className={isListening ? 'bg-red-500' : ''}
              >
                <Mic className="h-4 w-4" />
              </Button>
              <Button
                variant="ghost"
                size="icon"
                onClick={() => setEditMode(!editMode)}
              >
                <Save className="h-4 w-4" />
              </Button>
              <Button
                variant="ghost"
                size="icon"
                onClick={deleteSection}
              >
                <Trash2 className="h-4 w-4" />
              </Button>
            </div>
          </CardHeader>
          <CardContent>
            {editMode ? (
              <Textarea
                value={currentSection?.content || ''}
                onChange={(e) => updateContent(e.target.value)}
                className="min-h-[400px] font-mono bg-gray-900 text-gray-100 border-gray-700"
                placeholder="Write in markdown..."
              />
            ) : (
              <div className="prose prose-invert max-w-none">
                {renderContent()}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Voice Control Help */}
        <Card className="mt-4 bg-gray-800 border-gray-700">
          <CardHeader>
            <CardTitle className="text-lg">Voice Commands</CardTitle>
          </CardHeader>
          <CardContent className="text-sm text-gray-400">
            <p>Say section name to navigate (e.g., "Lyrics", "Notes")</p>
            <p>"New" or "Add" to create section</p>
            <p>"Edit" to enable editing</p>
            <p>"Save" to disable editing</p>
          </CardContent>
        </Card>
      </div>
    </div>
  );
};

export default MobileWiki;
