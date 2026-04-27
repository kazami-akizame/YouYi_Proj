// utils/PreferenceUtil.ets
import preferences from '@ohos.data.preferences';
import { common } from '@kit.AbilityKit';

// 直接使用 ArkTS 支持的 BaseContext 类型
let appContext: common.BaseContext | null = null;

export class PreferenceUtil {
  // 必须在应用入口（比如 EntryAbility.ets）初始化一次
  static init(ctx: common.BaseContext): void {
    appContext = ctx;
  }

  // 保存字符串
  static async setValue(key: string, value: string): Promise<void> {
    if (!appContext) {
      console.error('请先调用 PreferenceUtil.init() 初始化上下文');
      return;
    }
    try {
      const pref = await preferences.getPreferences(appContext, 'user_info');
      await pref.put(key, value);
      await pref.flush();
    } catch (err) {
      console.error('保存失败:', JSON.stringify(err));
    }
  }

  // 获取字符串
  static async getValue(key: string): Promise<string | null> {
    if (!appContext) {
      console.error('请先调用 PreferenceUtil.init() 初始化上下文');
      return null;
    }
    try {
      const pref = await preferences.getPreferences(appContext, 'user_info');
      const val = await pref.get(key, '') as string;
      return val === '' ? null : val;
    } catch (err) {
      console.error('获取失败:', JSON.stringify(err));
      return null;
    }
  }

  // 清除所有数据
  static async clear(): Promise<void> {
    if (!appContext) {
      console.error('请先调用 PreferenceUtil.init() 初始化上下文');
      return;
    }
    try {
      const pref = await preferences.getPreferences(appContext, 'user_info');
      await pref.clear();
      await pref.flush();
    } catch (err) {
      console.error('清除失败:', JSON.stringify(err));
    }
  }
}