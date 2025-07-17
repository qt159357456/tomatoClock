import { preferences } from "@kit.ArkData";
import { common } from "@kit.AbilityKit";

//本地存储
export class PreferenceStorage{
  static dataPreferences: preferences.Preferences | null = null;
  // 初始化函数
  static init(context: common.UIAbilityContext) {
    let options: preferences.Options = { name: 'myStore' };
    PreferenceStorage.dataPreferences = preferences.getPreferencesSync(context, options);
  }
  // 设置本地数据
  static set(name:string,value:string){
    PreferenceStorage.dataPreferences?.putSync(name,value)
    PreferenceStorage.dataPreferences?.flush(err=>{
      console.log("本地首选项存储失败")
    })
  }
  //拿到本地数据
  static get(name:string){
    return PreferenceStorage.dataPreferences?.getSync(name,'') as string
  }
  //删除本地数据
  static del(name:string){
    PreferenceStorage.dataPreferences?.deleteSync(name)
  }

}