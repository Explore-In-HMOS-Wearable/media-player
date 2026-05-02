import { preferences } from '@kit.ArkData';

export class PlaybackResumeService {
  static instance: PlaybackResumeService;
  private positions: Map<string, number> = new Map();
  private store: preferences.Preferences | null = null;

  static getInstance(): PlaybackResumeService {
    if (!PlaybackResumeService.instance) {
      PlaybackResumeService.instance = new PlaybackResumeService();
    }
    return PlaybackResumeService.instance;
  }

  async init(context: Context): Promise<void> {
    this.store = await preferences.getPreferences(context, 'playback_store');
    const raw = await this.store.get('positions', '{}') as string;
    const obj: Record<string, number> = JSON.parse(raw) as Record<string, number>;
    for (const key of Object.keys(obj)) {
      this.positions.set(key, obj[key]);
    }
  }

  getPosition(videoId: string): number {
    return this.positions.get(videoId) ?? 0;
  }

  async savePosition(videoId: string, positionMs: number): Promise<void> {
    this.positions.set(videoId, positionMs);
    await this.save();
  }

  private async save(): Promise<void> {
    if (this.store) {
      const obj: Record<string, number> = {};
      this.positions.forEach((value, key) => {
        obj[key] = value;
      });
      await this.store.put('positions', JSON.stringify(obj));
      await this.store.flush();
    }
  }
}
