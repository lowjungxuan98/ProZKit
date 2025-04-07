//
//  Crypto.swift
//  ProZKit
//
//  Created by Low Jung Xuan on 7/4/25.
//

import Foundation
import CommonCrypto
import CryptoKit

extension ProZKit {
    private static func md5Data(_ str: String) -> Data {
        let data = Data(str.utf8)
        var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        digest.withUnsafeMutableBytes { digestBytes in
            data.withUnsafeBytes { dataBytes in
                CC_MD5(dataBytes.baseAddress, CC_LONG(data.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        return digest
    }
    
    private static let key: Data = {
        var k = md5Data("RMS")
        k.append(k.prefix(8))
        return k
    }()
    
    public static func encrypt(_ s: String) -> String? {
        guard let data = s.data(using: .utf8),
              let encrypted = crypt(data: data, op: CCOperation(kCCEncrypt))
        else { return nil }
        return encrypted.base64EncodedString()
    }
    
    public static func decrypt(_ s: String) -> String? {
        guard let data = Data(base64Encoded: s),
              let decrypted = crypt(data: data, op: CCOperation(kCCDecrypt))
        else { return nil }
        return String(data: decrypted, encoding: .utf8)
    }
    
    private static func crypt(data: Data, op: CCOperation) -> Data? {
        var outLength: size_t = 0
        let bufferSize = data.count + kCCBlockSize3DES
        var outData = Data(count: bufferSize)
        let status = outData.withUnsafeMutableBytes { outPtr in
            data.withUnsafeBytes { dataPtr in
                key.withUnsafeBytes { keyPtr in
                    CCCrypt(
                        op,
                        CCAlgorithm(kCCAlgorithm3DES),
                        CCOptions(kCCOptionPKCS7Padding | kCCOptionECBMode),
                        keyPtr.baseAddress, kCCKeySize3DES,
                        nil,
                        dataPtr.baseAddress, data.count,
                        outPtr.baseAddress, bufferSize,
                        &outLength
                    )
                }
            }
        }
        guard status == kCCSuccess else { return nil }
        return Data(outData[0..<outLength])
    }
}
