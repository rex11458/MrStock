#pragma once

#import <Foundation/Foundation.h>

//-----Code Define-------------
#define UC_CODE_AUTOPUSH				0x0010		//行情自动推送
#define UC_CODE_SENCONDPACKET			0x0fff		//二次封包


//----Attribute Type define------
#define UC_ATTR_CODEINFO				0x10		//代码信息CodeInfo结构
#define UC_ATTR_SENCONDPACKET			0xff		//二次封包传送

//----Response Attribute type define------
#define UC_RES_ATTR_REALTIME			0x10		//实行行情数据
#define UC_RES_ATTR_SENCONDPACKET		0xff		//二次封包传送

#pragma	pack(1)

//包头
typedef struct _UUCommHead{
    
	unsigned short		code;				// 功能编码
	char				cIdentifier;		// 标识符，要求每个包唯一
	int					nLength;			// 包的总长度
	char				cAuthenticator[64];	//鉴别码，目前暂为32位head的md5标识串，后32位整体包的md5校验串
    
} UUCommHead;

BOOL UUCommHead_ValidHead(UUCommHead* pHead);			//判断包头(Head)的合法性
void UUCommHead_CreateAuthenticator(UUCommHead *pHead); //生成包头(Head)部份的鉴别码
void UUCommHead_setIdentifier(UUCommHead *pHead);		//生成标识符

//请求包或接收包g
typedef struct _UUCommAttributes{
	UUCommHead			head;
	char				cAttributes[1];		//属性，UUCommAttribute的总长度
    
}UUCommRequest,UUCommResponse;

BOOL UUCommRequest_Valid(UUCommRequest* pRequest);					//判断整个包的合法性
void UUCommRequest_CreateAuthenticator(UUCommRequest* pRequest);		//生成整个包的鉴别码
int UUCommRequest_getAttributesLength(UUCommRequest* pRequest);		//获取属性的总长度


//单个属性结构
typedef struct _UUCommAttribute{
	char				type;
	unsigned int		length;
	char				cAttribute[1];		//长度取决于length
    
}UUCommAttribute;

int UUCommAttribute_getTotalLength(UUCommAttribute* pAttribute);					//获取整个属性的长度







