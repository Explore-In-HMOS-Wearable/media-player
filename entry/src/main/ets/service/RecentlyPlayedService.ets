import { preferences } from '@kit.ArkData';

export class RecentItem {
  videoId: string;
  videoName: string;
  timestamp: number;

  constructor(videoId: string, videoName: string, timestamp: number) {
    this.videoId = videoId;
    this.videoName = videoName;
    this.timestamp = timestamp;
  }
}

export class RecentlyPlayedService {
  static instance: RecentlyPlayedService;
  private recentList: RecentItem[] = [];
  private store: preferences.Preferences | null = null;
  private maxItems: number = 10;

  static getInstance(): RecentlyPlayedService {
    if (!RecentlyPlayedService.instance) {
      RecentlyPlayedService.instance = new RecentlyPlayedService();
    }
    return RecentlyPlayedService.instance;
  }

  async init(context: Context): Promise<void> {
    this.store = await preferences.getPreferences(context, 'recent_store');
    const raw = await this.store.get('recent', '[]') as string;
    this.recentList = JSON.parse(raw) as RecentItem[];
  }

  async addRecent(videoId: string, videoName: string): Promise<void> {
    this.recentList = this.recentList.filter(item => item.videoId !== videoId);
    this.recentList.unshift(new RecentItem(videoId, videoName, Date.now()));
    if (this.recentList.length > this.maxItems) {
      this.recentList = this.recentList.slice(0, this.maxItems);
    }
    await this.save();
  }

  getRecentList(): RecentItem[] {
    return this.recentList;
  }

  private async save(): Promise<void> {
    if (this.store) {
      await this.store.put('recent', JSON.stringify(this.recentList));
      await this.store.flush();
    }
  }
}
