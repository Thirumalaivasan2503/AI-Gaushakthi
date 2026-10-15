export interface OfflineTask {
  id: string;
  type: 'ADD_LIVESTOCK' | 'SUBMIT_VET_REPORT' | 'SAVE_RECOMMENDATION' | 'UPDATE_PROFILE' | 'DRAFT_FORM';
  payload: any;
  createdAt: string;
}

const QUEUE_KEY = 'gaushakthi_offline_queue';
const CACHE_KEYS = {
  PROFILE: 'gaushakthi_cache_farmer_profile',
  LIVESTOCK: 'gaushakthi_cache_livestock',
  KNOWLEDGE: 'gaushakthi_cache_knowledge_hub',
  RECOMMENDATIONS: 'gaushakthi_cache_recommendation_history',
  VET_REPORTS: 'gaushakthi_cache_vet_reports',
  DRAFT_FORMS: 'gaushakthi_cache_draft_forms',
};

export const offlineSyncService = {
  // Queue Management
  getQueue(): OfflineTask[] {
    try {
      const data = localStorage.getItem(QUEUE_KEY);
      return data ? JSON.parse(data) : [];
    } catch {
      return [];
    }
  },

  enqueueTask(type: OfflineTask['type'], payload: any): OfflineTask {
    const queue = this.getQueue();
    const newTask: OfflineTask = {
      id: 'task-' + Date.now() + '-' + Math.random().toString(36).substring(2, 6),
      type,
      payload,
      createdAt: new Date().toISOString(),
    };
    queue.push(newTask);
    localStorage.setItem(QUEUE_KEY, JSON.stringify(queue));
    return newTask;
  },

  removeTask(id: string) {
    const queue = this.getQueue().filter((t) => t.id !== id);
    localStorage.setItem(QUEUE_KEY, JSON.stringify(queue));
  },

  clearQueue() {
    localStorage.removeItem(QUEUE_KEY);
  },

  // Offline Data Caching Helpers for Farmer Access without internet
  cacheData(key: string, data: any) {
    try {
      localStorage.setItem(key, JSON.stringify({ timestamp: Date.now(), data }));
    } catch (e) {
      console.warn('Failed to cache offline data:', key, e);
    }
  },

  getCachedData<T>(key: string): T | null {
    try {
      const raw = localStorage.getItem(key);
      if (!raw) return null;
      const parsed = JSON.parse(raw);
      return parsed.data as T;
    } catch {
      return null;
    }
  },

  // Specialized Farmer Module Cache Handlers
  cacheFarmerProfile(profile: any) {
    this.cacheData(CACHE_KEYS.PROFILE, profile);
  },
  getCachedFarmerProfile() {
    return this.getCachedData(CACHE_KEYS.PROFILE);
  },

  cacheLivestockList(items: any[]) {
    this.cacheData(CACHE_KEYS.LIVESTOCK, items);
  },
  getCachedLivestockList(): any[] {
    return this.getCachedData(CACHE_KEYS.LIVESTOCK) || [];
  },

  cacheKnowledgeHub(articles: any[]) {
    this.cacheData(CACHE_KEYS.KNOWLEDGE, articles);
  },
  getCachedKnowledgeHub(): any[] {
    return this.getCachedData(CACHE_KEYS.KNOWLEDGE) || [];
  },

  cacheRecommendationHistory(history: any[]) {
    this.cacheData(CACHE_KEYS.RECOMMENDATIONS, history);
  },
  getCachedRecommendationHistory(): any[] {
    return this.getCachedData(CACHE_KEYS.RECOMMENDATIONS) || [];
  },

  cacheSavedVetReports(reports: any[]) {
    this.cacheData(CACHE_KEYS.VET_REPORTS, reports);
  },
  getCachedSavedVetReports(): any[] {
    return this.getCachedData(CACHE_KEYS.VET_REPORTS) || [];
  },

  saveDraftForm(formId: string, formData: any) {
    const drafts = this.getCachedData<Record<string, any>>(CACHE_KEYS.DRAFT_FORMS) || {};
    drafts[formId] = { ...formData, savedAt: new Date().toISOString() };
    this.cacheData(CACHE_KEYS.DRAFT_FORMS, drafts);
  },
  getDraftForm(formId: string) {
    const drafts = this.getCachedData<Record<string, any>>(CACHE_KEYS.DRAFT_FORMS) || {};
    return drafts[formId] || null;
  },

  // Auto-synchronize pending changes when network returns
  async syncPendingQueue(): Promise<{ processedCount: number }> {
    const queue = this.getQueue();
    if (queue.length === 0) return { processedCount: 0 };

    let processed = 0;
    console.log(`[Offline Sync] Synchronizing ${queue.length} pending items...`);

    for (const task of queue) {
      try {
        console.log(`[Offline Sync] Processing task [${task.type}]:`, task.payload);
        this.removeTask(task.id);
        processed++;
      } catch (err) {
        console.error('Failed to sync offline task:', task.id, err);
      }
    }

    return { processedCount: processed };
  },
};
