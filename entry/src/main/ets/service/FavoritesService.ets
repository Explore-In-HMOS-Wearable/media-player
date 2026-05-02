import { preferences } from '@kit.ArkData';

export class FavoritesService {
  static instance: FavoritesService;
  private favorites: Set<string> = new Set();
  private store: preferences.Preferences | null = null;

  static getInstance(): FavoritesService {
    if (!FavoritesService.instance) {
      FavoritesService.instance = new FavoritesService();
    }
    return FavoritesService.instance;
  }

  async init(context: Context): Promise<void> {
    this.store = await preferences.getPreferences(context, 'favorites_store');
    const raw = await this.store.get('favorites', '[]') as string;
    const arr: string[] = JSON.parse(raw) as string[];
    this.favorites = new Set(arr);
  }

  isFavorite(videoId: string): boolean {
    return this.favorites.has(videoId);
  }

  async toggleFavorite(videoId: string): Promise<void> {
    if (this.favorites.has(videoId)) {
      this.favorites.delete(videoId);
    } else {
      this.favorites.add(videoId);
    }
    await this.save();
  }

  getFavoriteIds(): string[] {
    return Array.from(this.favorites);
  }

  private async save(): Promise<void> {
    if (this.store) {
      await this.store.put('favorites', JSON.stringify(Array.from(this.favorites)));
      await this.store.flush();
    }
  }
}
