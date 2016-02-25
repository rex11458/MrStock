//#include "UUstdafx.h.h"
#include "UUCommStruct.h.h"
//#include "md5.h"
#import <CommonCrypto/CommonDigest.h>

#define UU_MD5_KEY "uusoft"

BOOL UUCommHead_ValidHead(UUCommHead* pHead){
    if (pHead == NULL) {
        return NO;
    }
    
	UUCommHead head;
	memcpy(&head, pHead, sizeof(UUCommHead));
	UUCommHead_CreateAuthenticator(&head);

	char oldAuthenticator[33];
	char newAuthenticator[33];
	memset(oldAuthenticator, 0, 33);
	memset(newAuthenticator, 0, 33);

	memcpy(oldAuthenticator, pHead->cAuthenticator, 32);
	memcpy(newAuthenticator, head.cAuthenticator, 32);

	return 0 == strcmp(oldAuthenticator, newAuthenticator);
}

void UUCommHead_CreateAuthenticator(UUCommHead *pHead){
	memset(pHead->cAuthenticator, 0, 64);
	memcpy(pHead->cAuthenticator, UU_MD5_KEY, 6);

    int nLen = sizeof(UUCommHead);
    const char *value = (const char*)pHead;
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, nLen, outputBuffer);
    
    char md5char[4];
    for(int count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        sprintf(md5char, "%02x", outputBuffer[count]);
        memcpy(pHead->cAuthenticator + 2 * count, md5char, 2);
    }
//    NSLog(@"%s", pHead->cAuthenticator);
}

void UUCommHead_setIdentifier(UUCommHead *pHead){
    static char identifier = 0;
	if ( identifier < 0xff)
	{
		identifier++;
	}else{
		identifier = 1;
	}

	pHead->cIdentifier = identifier;
}

BOOL UUCommRequest_Valid(UUCommRequest* pRequest){
    
    if (pRequest == NULL) return NO;
    
	char* compare = (char*)malloc(pRequest->head.nLength);

    memcpy(compare, pRequest, pRequest->head.nLength);

	struct _UUCommAttributes* pAttributes = (struct _UUCommAttributes*)compare;

	UUCommRequest_CreateAuthenticator(pAttributes);

	char oldAuthenticator[33];
	char newAuthenticator[33];
	memset(oldAuthenticator, 0, 33);
	memset(newAuthenticator, 0, 33);

	memcpy(oldAuthenticator, &pRequest->head.cAuthenticator[32], 32);
	memcpy(newAuthenticator, &pAttributes->head.cAuthenticator[32], 32);

	free(compare);
    
    NSLog(@"%s,%s", oldAuthenticator, newAuthenticator);

	return 0 == strcmp(oldAuthenticator, newAuthenticator);
}

void UUCommRequest_CreateAuthenticator(UUCommRequest* pRequest){
	memset(&pRequest->head.cAuthenticator[32], 0, 32);
	memcpy(&pRequest->head.cAuthenticator[32], UU_MD5_KEY, 6);

    const unsigned char *value = (const unsigned char*)pRequest;
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, pRequest->head.nLength, outputBuffer);
    
    char md5char[4];
    for(int count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        sprintf(md5char, "%02x", outputBuffer[count]);
        memcpy(&pRequest->head.cAuthenticator[32 + 2 * count], md5char, 2);
    }
    
//	MD5 md5;
//	md5.feed((const unsigned char*)pRequest, pRequest->head.nLength);
//	std::string sAuthenticator = md5.hex();
//	memcpy(&pRequest->head.cAuthenticator[32], sAuthenticator.c_str(), sAuthenticator.length());
}

int UUCommRequest_getAttributesLength(UUCommRequest* pRequest){
	return pRequest->head.nLength - sizeof(UUCommHead);
}


int UUCommAttribute_getTotalLength(UUCommAttribute* pAttribute){
	return sizeof(UUCommAttribute) - 1 + pAttribute->length;
}