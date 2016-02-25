
#ifndef CDataBuffer_H_
#define CDataBuffer_H_
#import <Foundation/Foundation.h>
//#pragma once

typedef struct Commflux
{
		long m_nRecieve;  // Ω” ’
		long m_nPreRecieve;  // …œ¥ŒΩ” ’
		long m_nSend;	  // ∑¢ÀÕ
		long m_nPreSend;	  // ∑¢ÀÕ
		
		long m_nVersion;  // µ±«∞∞Ê±æ
		char m_cPrompt;   // ∞Ê±æÃ· æ¥Œ ˝
		
		char m_cSynSrv;   //  ˝æ›∏¸–¬¿‡–Õ,0Œ™≤ªÀ¢–¬£¨15,30,60√ÎÀ¢–¬£¨1Œ™”Î÷˜’æÕ¨≤Ω
		
		char m_cUsedHtml;	   //  π”√htmlÕ®—∂
		char m_cUsedHttpProxy; //  π”√http¥˙¿Ì
		char m_cCheckNet;
}Commflux;


@interface UUCDataBuffer : NSObject
{
@public	
	char *m_pszBuffer;
	long m_cbBuffer;
	long m_nIndex;
    bool m_bGetLength;
}

@property char *m_pszBuffer;
@property long  m_cbBuffer;
@property long  m_nIndex;
@property bool  m_bGetLength;

-(id) init;
- (void) dealloc;

-(void) CDataBuffer_;
-(void) _CDataBuffer;

-(BOOL) Alloc:(int) nSize;
-(void) Free;

@end

#endif
