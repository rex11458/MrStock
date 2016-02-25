
//#include "UUstdafx.h.h"
#include "UUDataBuffer.h.h"

@implementation UUCDataBuffer

@synthesize m_pszBuffer;
@synthesize m_cbBuffer;
@synthesize m_nIndex;
@synthesize m_bGetLength;

-(id) init
{
	self = [super init];
	if( self != nil )
		[self CDataBuffer_];
	return self;
}

- (void) dealloc
{   
	[self _CDataBuffer];
//    [super dealloc];
}

-(void) CDataBuffer_
{
	m_pszBuffer = NULL;
	m_cbBuffer = 0;
	m_nIndex = 0;
    m_bGetLength = FALSE;
}

-(void) _CDataBuffer
{
	[self Free];		
}

-(BOOL) Alloc:(int) nSize
{
	[self Free];

	if( nSize <= 0 )
		return FALSE;

	m_pszBuffer = (char*)malloc(nSize);
	if (m_pszBuffer)
	{
        memset(m_pszBuffer, 0x00, nSize);
		m_cbBuffer = nSize;
		m_nIndex = 0;

		return TRUE;
	}
	return FALSE;
}

-(void) Free
{		
	if (m_pszBuffer)
	{
		free(m_pszBuffer);
		m_pszBuffer = NULL;
		m_cbBuffer = 0;
		m_nIndex = 0;
        m_bGetLength = FALSE;
	}
}

@end
