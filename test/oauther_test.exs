defmodule OAutherTest do
  use ExUnit.Case

  test "HMAC-SHA1 signature" do
    creds = OAuther.credentials(consumer_secret: "kd94hf93k423kf44", token_secret: "pfkkdhi9sl3r4s00", consumer_key: "dpf43f3p2l4k3l03", token: "nnch734d00sl2jdk")

    assert signature(protocol_params(creds), creds) == "tR3+Ty81lMeYAr/Fid0kMTYa/WM="
  end

  test "RSA-SHA1 signature" do
    creds = OAuther.credentials(method: :rsa_sha1, consumer_secret: fixture_path("qwe.pem"), consumer_key: "dpf43f3p2l4k3l03")

    assert signature(protocol_params(creds), creds) == "cyZ9hTJnRfkOnF5+OzxXWKKG+hRY+/esxdQAluJem1RlHkZQRsFEevOS5x+A1ZoS+aYlTU3xdHkEKIb/+xuqaavAUFVaIF/5448XsXqSTJomvpoC1c7yw5ArNZnPRLYwK3XYHaIr5FHXbiCG/ze093i2MpsusQU6Shn8lGJNMWE="
  end

  test "PLAINTEXT signature" do
    creds = OAuther.credentials(method: :plaintext, consumer_secret: "cnil", consumer_key: "dpf43f3p2l4k3l03")

    assert signature([], creds) == "cnil&"
  end

  defp fixture_path(file_path) do
    Path.expand("fixtures", __DIR__)
    |> Path.join(file_path)
  end

  defp protocol_params(creds) do
    OAuther.protocol_params([file: "vacation.jpg", size: "original"], creds)
    |> rewrite
  end

  defp rewrite(params) do
    for param <- params do
      case param do
        {"oauth_nonce", _} ->
          put_elem(param, 1, "kllo9940pd9333jh")

        {"oauth_timestamp", _} ->
          put_elem(param, 1, 1191242096)

        _ -> param
      end
    end
  end

  defp signature(params, creds) do
    OAuther.signature("get", "http://photos.example.net/photos", params, creds)
  end
end