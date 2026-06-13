const disconnectedCodeDisconnectCalled = 0;
const disconnectedCodeUnauthorized = 1;
const disconnectCodeBadProtocol = 2;
const disconnectCodeMessageSizeLimit = 3;
const disconnectedCodeClientClosed = 4;

const connectingCodeConnectCalled = 0;
const connectingCodeTransportClosed = 1;
const connectingCodeNoPing = 2;
const connectingCodeSubscribeTimeout = 3;
const connectingCodeUnsubscribeError = 4;

const subscribingCodeSubscribeCalled = 0;
const subscribingCodeTransportClosed = 1;

const unsubscribedCodeUnsubscribeCalled = 0;
const unsubscribedCodeUnauthorized = 1;
const unsubscribedCodeClientClosed = 2;

// Subscription feature flags — bitmask sent in SubscribeRequest.flag.
//
// channelCompaction asks the server to replace the string channel name with a
// short numeric ID in subscription pushes (bandwidth optimization). Safe to
// request unconditionally: servers that don't support or don't allow it simply
// ignore the bit and keep sending the full channel name.
const subscriptionFlagChannelCompaction = 1;
const subscriptionFlagRejectUnrecovered = 2;

// Server error code returned when recovery from the provided position is
// impossible (only sent when subscriptionFlagRejectUnrecovered was requested).
const errorCodeUnrecoverablePosition = 112;
