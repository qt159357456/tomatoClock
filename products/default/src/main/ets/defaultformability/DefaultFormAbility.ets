import { formBindingData, FormExtensionAbility, formInfo, formProvider } from '@kit.FormKit';
import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

// 定义卡片数据结构接口
interface WidgetData {
  title: string;
  currentTime: number;
}

export default class DefaultFormAbility extends FormExtensionAbility {
  onAddForm(want: Want):formBindingData.FormBindingData {
    // 初始卡片数据（使用显式类型）
    const formData: WidgetData = {
      title: "专注任务",
      currentTime: 1500 // 25分钟 = 1500秒
    };
    const formId = want.parameters![formInfo.FormParam.IDENTITY_KEY] as string;
    console.log('formId is',formId);
    AppStorage.setOrCreate('formId', formId);
    return formBindingData.createFormBindingData(formData);
  }

  onUpdateForm(formId: string) {
    // 这里可以添加更新卡片数据的逻辑
    // 例如：从主应用获取最新任务信息
    const updatedData: WidgetData = {
      title: "新任务名称",
      currentTime: 1200 // 20分钟
    };

    // 更新卡片
    formProvider.updateForm(formId, formBindingData.createFormBindingData(updatedData))
      .catch((err: BusinessError) => {
        console.error(`Failed to update form. Code: ${err.code}, message: ${err.message}`);
      });
  }

  onCastToNormalForm(formId: string) {
    // Called when the form provider is notified that a temporary form is successfully
    // converted to a normal form.
  }

  onFormEvent(formId: string, message: string) {
    // Called when a specified message event defined by the form provider is triggered.
  }

  onRemoveForm(formId: string) {
    // Called to notify the form provider that a specified form has been destroyed.
  }

  onAcquireFormState(want: Want) {
    // Called to return a {@link FormState} object.
    return formInfo.FormState.READY;
  }
}