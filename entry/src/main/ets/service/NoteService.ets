import { preferences } from '@kit.ArkData';

export class NoteItem {
  id: string;
  title: string;
  content: string;
  timestamp: number;

  constructor(id: string, title: string, content: string, timestamp: number) {
    this.id = id;
    this.title = title;
    this.content = content;
    this.timestamp = timestamp;
  }
}

export class NoteService {
  static instance: NoteService;
  private notes: NoteItem[] = [];
  private store: preferences.Preferences | null = null;
  currentEditId: string = '';
  currentEditTitle: string = '';
  currentEditContent: string = '';

  static getInstance(): NoteService {
    if (!NoteService.instance) {
      NoteService.instance = new NoteService();
    }
    return NoteService.instance;
  }

  async init(context: Context): Promise<void> {
    this.store = await preferences.getPreferences(context, 'notes_store');
    const raw = await this.store.get('notes', '[]') as string;
    this.notes = JSON.parse(raw) as NoteItem[];
  }

  getNotes(): NoteItem[] {
    return this.notes;
  }

  async addNote(title: string, content: string): Promise<void> {
    const id = Date.now().toString();
    this.notes.unshift(new NoteItem(id, title, content, Date.now()));
    await this.save();
  }

  async updateNote(id: string, title: string, content: string): Promise<void> {
    const idx = this.notes.findIndex(n => n.id === id);
    if (idx >= 0) {
      this.notes[idx].title = title;
      this.notes[idx].content = content;
      this.notes[idx].timestamp = Date.now();
      await this.save();
    }
  }

  async deleteNote(id: string): Promise<void> {
    this.notes = this.notes.filter(n => n.id !== id);
    await this.save();
  }

  private async save(): Promise<void> {
    if (this.store) {
      await this.store.put('notes', JSON.stringify(this.notes));
      await this.store.flush();
    }
  }
}
