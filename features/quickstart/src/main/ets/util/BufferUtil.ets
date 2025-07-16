import { util } from '@kit.ArkTS';

//将buffer转换成string
export function bufferToString(buffer: Uint8Array):string{
  let textDecoder = util.TextDecoder.create('utf-8', {
    ignoreBOM: true
  });
  let resultPut = textDecoder.decodeToString(buffer);
  return resultPut;
}