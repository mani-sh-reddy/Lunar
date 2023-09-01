//
//  DecodableDefault.swift
//  Lunar
//
//  Created by Mani on 01/09/2023.
//

import Foundation

@propertyWrapper
struct DecodableBool {
  var wrappedValue = false
}

extension DecodableBool: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    wrappedValue = try container.decode(Bool.self)
  }
}

extension KeyedDecodingContainer {
  func decode(_ type: DecodableBool.Type,
              forKey key: Key) throws -> DecodableBool {
    try decodeIfPresent(type, forKey: key) ?? .init()
  }
}

protocol DecodableDefaultSource {
  associatedtype Value: Decodable
  static var defaultValue: Value { get }
}

enum DecodableDefault {}

extension DecodableDefault {
  @propertyWrapper
  struct Wrapper<Source: DecodableDefaultSource> {
    typealias Value = Source.Value
    var wrappedValue = Source.defaultValue
  }
}

extension DecodableDefault.Wrapper: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    wrappedValue = try container.decode(Value.self)
  }
}

extension KeyedDecodingContainer {
  func decode<T>(_ type: DecodableDefault.Wrapper<T>.Type,
                 forKey key: Key) throws -> DecodableDefault.Wrapper<T> {
    try decodeIfPresent(type, forKey: key) ?? .init()
  }
}

extension DecodableDefault {
  typealias Source = DecodableDefaultSource
  typealias List = Decodable & ExpressibleByArrayLiteral
  typealias Map = Decodable & ExpressibleByDictionaryLiteral
  
  enum Sources {
    enum True: Source {
      static var defaultValue: Bool { true }
    }
    
    enum False: Source {
      static var defaultValue: Bool { false }
    }
    
    enum EmptyString: Source {
      static var defaultValue: String { "" }
    }
    
    enum ZeroInt: Source {
      static var defaultValue: Int { 0 }
    }
    
    enum EmptyList<T: List>: Source {
      static var defaultValue: T { [] }
    }
    
    enum EmptyMap<T: Map>: Source {
      static var defaultValue: T { [:] }
    }
  }
}

extension DecodableDefault {
  typealias True = Wrapper<Sources.True>
  typealias False = Wrapper<Sources.False>
  typealias EmptyString = Wrapper<Sources.EmptyString>
  typealias ZeroInt = Wrapper<Sources.ZeroInt>
  typealias EmptyList<T: List> = Wrapper<Sources.EmptyList<T>>
  typealias EmptyMap<T: Map> = Wrapper<Sources.EmptyMap<T>>
}

extension DecodableDefault.Wrapper: Equatable where Value: Equatable {}
extension DecodableDefault.Wrapper: Hashable where Value: Hashable {}

extension DecodableDefault.Wrapper: Encodable where Value: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(wrappedValue)
  }
}
