# frozen_string_literal: true

module RankHelper
  #for development im hosting these on a free website, when i push this to production will need to host images on S3 or something
  def self.rank(rank)
    rank_img_link = {
      "Unranked" => "",
      "Iron 1" => "https://i.ibb.co/DfrN4Qxn/Iron-1-Rank.png",
      "Iron 2" => "https://i.ibb.co/GQSPDnS2/Iron-2-Rank.png",
      "Iron 3" => "https://i.ibb.co/Z17M4LRR/Iron-3-Rank.png",
      "Bronze 1" => "https://i.ibb.co/Wb7YztV/Bronze-1-Rank.png",
      "Bronze 2" => "https://i.ibb.co/9HQ4pkWH/Bronze-2-Rank.png",
      "Bronze 3" => "https://i.ibb.co/PZSTbbzb/Bronze-3-Rank.png",
      "Silver 1" => "https://i.ibb.co/Fc8vrnt/Silver-1-Rank.png",
      "Silver 2" => "https://i.ibb.co/ZzWGnBmd/Silver-2-Rank.png",
      "Silver 3" => "https://i.ibb.co/0jqqpws8/Silver-3-Rank.png",
      "Gold 1" => "https://i.ibb.co/rKKHpm0x/Gold-1-Rank.png",
      "Gold 2" => "https://i.ibb.co/gZ0z0fHS/Gold-2-Rank.png",
      "Gold 3" => "https://i.ibb.co/0VvRLXmg/Gold-3-Rank.png",
      "Platinum 1" => "https://i.ibb.co/tTkDXHnF/Platinum-1-Rank.png",
      "Platinum 2" => "https://i.ibb.co/7tfLpG7w/Platinum-2-Rank.png",
      "Platinum 3" => "https://i.ibb.co/1Y8KdJxP/Platinum-3-Rank.png",
      "Diamond 1" => "https://i.ibb.co/KpRc8Q8q/Diamond-1-Rank.png",
      "Diamond 2" => "https://i.ibb.co/KjS3G6WP/Diamond-2-Rank.png",
      "Diamond 3" => "https://i.ibb.co/FLvV7ry4/Diamond-3-Rank.png",
      "Ascendant 1" => "https://i.ibb.co/Swm8TvVH/Ascendant-1-Rank.png",
      "Ascendant 2" => "https://i.ibb.co/6Jb5J9nb/Ascendant-2-Rank.png",
      "Ascendant 3" => "https://i.ibb.co/VhZ6wS1/Ascendant-3-Rank.png",
      "Immortal 1" => "https://i.ibb.co/jZxNmCS2/Immortal-1-Rank.png",
      "Immortal 2" => "https://i.ibb.co/xqcKxj7W/Immortal-2-Rank.png",
      "Immortal 3" => "https://i.ibb.co/BHZ550B6/Immortal-3-Rank.png",
      "Radiant" => "https://i.ibb.co/tPnm0fKK/Radiant-Rank.png"
    }

    rank_img_link[rank]
  end
end
